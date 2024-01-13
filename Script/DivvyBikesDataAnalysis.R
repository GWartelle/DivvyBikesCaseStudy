# Updating needed R packages
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("skimr", quietly = TRUE)) install.packages("skimr")
if (!requireNamespace("RANN", quietly = TRUE)) install.packages("RANN")
if (!requireNamespace("patchwork", quietly = TRUE)) install.packages("patchwork")
if (!requireNamespace("RColorBrewer", quietly = TRUE)) install.packages("RColorBrewer")
if (!requireNamespace("tibble", quietly = TRUE)) install.packages("tibble")

# Loading needed R packages
library(tidyverse)
library(skimr)
library(RANN)
library(patchwork)
library(RColorBrewer)
library(tibble)

# Binding all 12 csv files into one
trip_data <- list.files("./Data/Study Data", full.names = TRUE) %>% 
  lapply(read_csv) %>% 
  bind_rows()

# Checking for correct column names
colnames(trip_data)

# Dataset summary
skim_without_charts(trip_data)

# Getting rid of duplicate rows
clean_data <- trip_data %>% 
  distinct(ride_id, .keep_all = TRUE)

# Converting categorical data into factors
clean_data$rideable_type <- factor(clean_data$rideable_type)
clean_data$member_casual <- factor(clean_data$member_casual)

# Dropping non significant NA values
clean_data <- clean_data %>%
  drop_na(end_lat, end_lng)

# Getting rid of coordinates outliers
clean_data <- clean_data %>% 
  filter(end_lat != 0, end_lng != 0)

# Creating a data table associating station ID with its corresponding station name
station_id <- clean_data %>%
  select(start_station_id, end_station_id) %>% 
  gather(key = "id_type", value = "station_id", start_station_id:end_station_id)

station_name <- clean_data %>% 
  select(start_station_name, end_station_name) %>% 
  gather(key = "name_type", value = "station_name", start_station_name:end_station_name)

true_stations <- cbind(station_id, station_name) %>%
  count(station_id, station_name) %>%
  na.omit() %>% 
  group_by(station_id) %>%
  slice_max(order_by = n, n = 1, with_ties = FALSE)

sum(duplicated(true_stations$station_id))
sum(duplicated(true_stations$station_name))

# Getting rid of duplicate station IDs
true_stations <- true_stations %>% 
  group_by(station_name) %>% 
  slice_max(order_by = n, n = 1, with_ties = FALSE) %>% 
  select(-n)

sum(duplicated(true_stations$station_id))
sum(duplicated(true_stations$station_name))

# Merging true_stations with clean_data and getting standardizing station names
clean_data <- clean_data %>% 
  left_join(true_stations, by = c("start_station_id" = "station_id"))
start_name_change <- !is.na(clean_data$start_station_name) &
  !is.na(clean_data$station_name) &
  clean_data$start_station_name != clean_data$station_name
clean_data$start_station_name[start_name_change] <- clean_data$station_name[start_name_change]
clean_data <- clean_data %>% 
  select(-station_name)

clean_data <- clean_data %>% 
  left_join(true_stations, by = c("end_station_id" = "station_id"))
end_name_change <- !is.na(clean_data$end_station_name) &
  !is.na(clean_data$station_name) &
  clean_data$end_station_name != clean_data$station_name
clean_data$end_station_name[end_name_change] <- clean_data$station_name[end_name_change]
clean_data <- clean_data %>% 
  select(-station_name)

skim_without_charts(clean_data)

# Creating a dataset to find a common theme between the rest of the missing values
na_check <- clean_data[!complete.cases(clean_data), ]
na_chart <- na_check %>% 
  count(member_casual, rideable_type) %>% 
  ggplot(mapping = aes(x = rideable_type, y = n, fill = rideable_type)) +
  geom_col() +
  facet_wrap(vars(member_casual))
na_chart

# Rounding coordinates to 5 digits and creating start and end location columns with coupled coordinates
clean_data <- clean_data %>%
  mutate(across(c('start_lat', 'start_lng', 'end_lat', 'end_lng'), \(x) round(x, digits = 5))) %>%
  mutate(start_location = paste(start_lat,start_lng,sep = ","),
         end_location = paste(end_lat,end_lng,sep = ","))

# Updating the true_stations dataset with coordinates columns
station_lng <- clean_data %>% 
  select(start_lng, end_lng) %>% 
  gather(key = "lng_type", value = "station_lng", start_lng:end_lng)

station_location <- clean_data %>% 
  select(start_location, end_location) %>% 
  gather(key = "location_type", value = "station_location", start_location:end_location)

true_stations <- cbind(station_id, station_name, station_lat, station_lng, station_location) %>%
  count(station_id, station_name, station_lat, station_lng, station_location) %>%
  na.omit() %>% 
  group_by(station_id) %>%
  slice_max(order_by = n, n = 1, with_ties = FALSE) %>% 
  group_by(station_name) %>% 
  slice_max(order_by = n, n = 1, with_ties = FALSE) %>% 
  select(-n)

sum(duplicated(true_stations$station_id))
sum(duplicated(true_stations$station_name))

# Creating a data subset with all the rows missing station names
start_missing <- clean_data %>% 
  select(ride_id, start_station_name, start_lng, start_lat) %>% 
  rename(start_missing_name = start_station_name) %>% 
  filter(is.na(start_missing_name))

end_missing <- clean_data %>% 
  select(ride_id, end_station_name, end_lng, end_lat) %>% 
  rename(end_missing_name = end_station_name) %>%
  filter(is.na(end_missing_name))

# Creating matrices to calculate the closest stations
start_coords <- as.matrix(start_missing[, c("start_lng", "start_lat")])
end_coords <- as.matrix(end_missing[, c("end_lng", "end_lat")])
true_coords <- as.matrix(true_stations[, c("station_lng", "station_lat")])

start_neighbors <- RANN::nn2(true_coords, start_coords, k = 1)$nn.idx
start_nearest_stations <- true_stations$station_name[start_neighbors]
start_missing$start_missing_name <- start_nearest_stations

end_neighbors <- RANN::nn2(true_coords, end_coords, k = 1)$nn.idx
end_nearest_stations <- true_stations$station_name[end_neighbors]
end_missing$end_missing_name <- end_nearest_stations

# Creating a dataset without station name duplicates
station_whole2 <- station_whole %>% 
  group_by(station_name) %>% 
  arrange(desc(source)) %>% 
  slice(1) %>% 
  select(station_name, longitude, latitude, location)

sum(duplicated(station_whole2$station_name))
sum(duplicated(station_whole2$location))

# Consolidating clean_data with the names of missing stations 
filling_stations <- full_join(start_missing, end_missing, by = "ride_id") %>% 
  select(ride_id, start_missing_name, end_missing_name)

clean_data <- clean_data %>%
  left_join(filling_stations, by = "ride_id")

clean_data$start_station_name <- ifelse(is.na(clean_data$start_station_name),
                                        clean_data$start_missing_name,
                                        clean_data$start_station_name)

clean_data$end_station_name <- ifelse(is.na(clean_data$end_station_name),
                                      clean_data$end_missing_name,
                                      clean_data$end_station_name)

clean_data <- clean_data %>%
  select(-start_missing_name, -end_missing_name)

skim_without_charts(clean_data)

# Standardizing start stations coordinates because of too much variability
true_stations <- true_stations %>% 
  select(-station_id)

clean_data <- clean_data %>% 
  left_join(true_stations, by = c("start_station_name" = "station_name"))
start_loc_change <- !is.na(clean_data$start_location) &
  !is.na(clean_data$station_location) &
  clean_data$start_location != clean_data$station_location
clean_data$start_location[start_loc_change] <- clean_data$station_location[start_loc_change]
clean_data$start_lat[start_loc_change] <- clean_data$station_lat[start_loc_change]
clean_data$start_lng[start_loc_change] <- clean_data$station_lng[start_loc_change]
clean_data <- clean_data %>%
  select(-station_lat, -station_lng, -station_location)

skim_without_charts(clean_data)

# Creating a new column with the distance in meters between the start and end stations using the Haversine function
start_lat <- clean_data$start_lat
start_lng <- clean_data$start_lng
end_lat <- clean_data$end_lat
end_lng <- clean_data$end_lng

start_lat_rad <- start_lat * pi / 180
start_lng_rad <- start_lng * pi / 180
end_lat_rad <- end_lat * pi / 180
end_lng_rad <- end_lng * pi / 180

delta_lat <- end_lat_rad - start_lat_rad
delta_lng <- end_lng_rad - start_lng_rad

a <- sin(delta_lat / 2)^2 + cos(start_lat_rad) * cos(end_lat_rad) * sin(delta_lng / 2)^2
c <- 2 * atan2(sqrt(a), sqrt(1 - a))

earth_radius <- 6371000
distances <- round((earth_radius * c), digits = -2)
clean_data$distance <- distances
summary(clean_data$distance)

# Creating a new variable with the duration of trips in minute
clean_data <- clean_data %>% 
  mutate("trip_duration" = round(difftime(ended_at, started_at, units = "mins")))
summary(as.numeric(clean_data$trip_duration))

# Setting up some variables to follow the Empirical rule
duration_mean <- as.numeric(round(mean(clean_data$trip_duration)))
duration_sd <- round(sd(clean_data$trip_duration))
outliers_limit <- as.numeric(round(duration_mean + (duration_sd * 3)))

# Getting rid of trip duration outliers 
clean_data <- clean_data %>% 
  filter(trip_duration > 0 & trip_duration <= outliers_limit)
summary(as.numeric(clean_data$trip_duration))

# Creating variables for time and date easier to work with
clean_data <- clean_data %>% 
  mutate("month" = month(started_at, label = TRUE , abbr = TRUE),
         "week" = week(started_at),
         "week_day" = wday(started_at, label = TRUE, abbr = TRUE),
         "hour" = hour(started_at))

levels(clean_data$week_day)
levels(clean_data$month)

# Checking and then standardizing the levels of factors
clean_data$week_day <- fct_relevel(clean_data$week_day, "lun\\.", "mar\\.", "mer\\.", "jeu\\.", "ven\\.", "sam\\.", "dim\\.")
levels(clean_data$week_day) <- c('Mon','Tue','Wed','Thu','Fri','Sat','Sun')
levels(clean_data$month) <- c("Jan","Feb","Mar","Apr","May","Jun",
                              "Jul","Aug","Sep","Oct","Nov","Dec")

# Keeping only the variables we'll be working with
processed_data <- clean_data %>% 
  select(-ride_id, -started_at, -ended_at, -start_station_id, -end_station_id, -start_location, -end_location)
head(processed_data, n=10)

skim_without_charts(processed_data)

# Saving the processed dataset as a RDS file
saveRDS(processed_data, file = "Output/Data/processed_data.rds")

# Clearing the workspace
rm(list = ls())

# Loading the processed dataset
processed_data <- readRDS(file = "Output/Data/processed_data.rds")

# Creating a theme for visualizations
work_theme <- theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))

# Getting the total number of members versus casual users
processed_data %>% 
  count(member_casual) %>% 
  pivot_wider(names_from = member_casual, values_from = n)

# Creating a circular diagram to represent rideable type usage
member_rideable <- processed_data %>% 
  filter(member_casual == "member") %>% 
  count(rideable_type) %>%
  ggplot(mapping = aes(x ="", y = n, fill=rideable_type)) +
  geom_bar(stat = "identity", width = 1, color="white") +
  scale_fill_manual(values = c("classic_bike"="#F8766D",
                               "electric_bike"="#619CFF")) +
  coord_polar("y", start = 0) +
  theme_void() +
  labs(title = "Member rideables") +
  theme(plot.title = element_text(hjust = 0.5))

casual_rideable <- processed_data %>% 
  filter(member_casual == "casual") %>% 
  count(rideable_type) %>%
  ggplot(mapping = aes(x ="", y = n, fill=rideable_type)) +
  geom_bar(stat = "identity", width = 1, color="white") +
  coord_polar("y", start = 0) +
  theme_void() +
  labs(title = "Casual rideables") +
  theme(plot.title = element_text(hjust = 0.5))

rideable_usage <- (member_rideable + casual_rideable) +
  plot_annotation(title = "Member vs. Casual rideables usage",
                  theme = theme(plot.title = element_text(hjust = 0.4)))
rideable_usage

# Creating a bar graph to represent the number of rides per trip duration
processed_data %>% 
  ggplot(mapping = aes(x = trip_duration, fill = rideable_type)) +
  geom_bar() +
  labs(title = "Member vs. Casual Trip duration",
       x = "Trip Duration in minutes",
       y = "Number of Rides") +
  work_theme +
  facet_grid(rows = vars(member_casual))

# Creating a chart showing the differences in average trip durations
processed_data %>%
  group_by(rideable_type, member_casual) %>% 
  summarise(mean_duration = mean(trip_duration)) %>% 
  ggplot(mapping = aes(x = rideable_type, y = as.numeric(mean_duration), fill = rideable_type)) +
  geom_bar(stat = "identity") +
  labs(title = "Member vs. Casual Trip duration per Rideable type",
       x = "Rideable type",
       y = "Average trip duration (in minutes)",
       fill = "Rideable type") +
  work_theme +
  coord_flip() +
  facet_grid(rows = vars(member_casual))

# Creating a chart showing the differences in average ride distances
processed_data %>%
  group_by(rideable_type, member_casual) %>% 
  summarise(mean_distance = mean(distance)) %>% 
  ggplot(mapping = aes(x = rideable_type, y = mean_distance, fill = rideable_type)) +
  geom_bar(stat = "identity") +
  labs(title = "Member vs. Casual distance between stations per rideable type",
       x = "Rideable type",
       y = "Average distance between start and end stations (in meters)",
       fill = "Rideable type") +
  work_theme +
  coord_flip() +
  facet_grid(rows = vars(member_casual))

# Creating a chart showcasing the differences in favorite stations
processed_data %>% 
  select(start_station_name, end_station_name) %>% 
  gather(key = "station_id", value = "station_name",
         start_station_name:end_station_name) %>% 
  cbind(member_casual = processed_data$member_casual) %>% 
  group_by(station_name, member_casual) %>% 
  summarise(count = n()) %>% 
  arrange(member_casual, desc(count)) %>% 
  group_by(member_casual) %>%
  top_n(5, count) %>% 
  ggplot(mapping = aes(x = reorder(station_name, desc(count)),
                       y = count, fill = station_name)) +
  geom_col() +
  labs(title = "Member vs. Casual Favorite stations",
       x = "Station names",
       y = "Number if times used",
       fill = "Station names") +
  work_theme +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_wrap(facets = vars(member_casual), scales = "free_x")

# Getting the average trip duration of members and casual riders
processed_data %>% 
  group_by(member_casual) %>% 
  summarise(mean_duration = mean(trip_duration)) %>% 
  pivot_wider(names_from = member_casual, values_from = mean_duration)

# Creating a chart showing the distribution of trip duration between the two groups
processed_data %>% 
  ggplot(mapping = aes(x = trip_duration, fill = rideable_type)) +
  geom_bar() +
  labs(title = "Member vs. Casual Trip duration",
       x = "Trip Duration in minutes",
       y = "Number of Rides") +
  work_theme +
  facet_grid(rows = vars(member_casual))

# Creating a bar graph to represent the number of rides per group of trip duration
processed_data %>% 
  mutate("trip_dur_per10" =
           ifelse(trip_duration<10, "0-10",
                  ifelse(trip_duration>=10 & trip_duration<20, "10-20",
                         ifelse(trip_duration>=20 & trip_duration<30, "20-30",
                                ifelse(trip_duration>=30 & trip_duration<40, "30-40",
                                       ifelse(trip_duration>=40 & trip_duration<50, "40-50","50+")))))) %>% 
  ggplot(mapping = aes(x = trip_dur_per10, fill = rideable_type)) +
  geom_bar() +
  labs(title = "Member vs. Casual Trip duration",
       x = "Trip Duration in minutes",
       y = "Number of Rides") +
  work_theme +
  facet_grid(rows = vars(member_casual))

# Creating a bar graph to represent the number of rides per group of trip distance
processed_data %>% 
  mutate("trip_dist_per_km" =
           ifelse(distance<1000, "0-1km",
                  ifelse(distance>=1000 & distance<2000, "1-2km",
                         ifelse(distance>=2000 & distance<3000, "2-3km",
                                ifelse(distance>=3000 & distance<4000, "3-4km",
                                       ifelse(distance>=4000 & distance<5000, "4-5km","5km+")))))) %>% 
  ggplot(mapping = aes(x = trip_dist_per_km, fill = rideable_type)) +
  geom_bar() +
  labs(title = "Member vs. Casual Trip distance",
       x = "Trip distance in kilometers",
       y = "Number of Rides") +
  work_theme +
  facet_grid(rows = vars(member_casual))

# Creating a bar graph to represent the number of rides per hour of the day
processed_data %>% 
  count(hour, member_casual) %>%
  mutate("daily_mean" = n/365) %>% 
  ggplot(mapping = aes(x = hour, y = daily_mean, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Member vs. Casual Starting Rides per hour",
       x = "Hour of the day",
       y = "Number of Rides") +
  work_theme

# Creating a bar graph to represent the average trip duration per hour of the day
processed_data %>%
  group_by(hour, member_casual) %>% 
  summarise(mean_duration = mean(trip_duration)) %>% 
  ggplot(mapping = aes(x = hour, y = mean_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Member vs. Casual Trip duration per hour",
       x = "Hours of the day",
       y = "Trip duration in minutes") +
  work_theme +
  scale_fill_brewer(palette = "Dark2")

# Creating bar graphs to represent the number of rides per hour over a week
processed_data %>%
  count(hour, week_day, member_casual) %>% 
  mutate("daily_mean" = n/365) %>%
  ggplot(mapping = aes(x = hour, y = daily_mean, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Member vs. Casual Daily Trips per Hour over the Week",
       x = "Hour of the day",
       y = "Number of Rides") +
  work_theme +
  facet_wrap(vars(week_day))

# Creating a bar graph to represent the average number of rides per day of the week
processed_data %>%
  count(week_day, member_casual) %>%
  mutate("weekly_mean" = n/52) %>% 
  ggplot(mapping = aes(x = week_day, y = weekly_mean, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Member vs. Casual Rides over a week",
       x = "Day of the week",
       y = "Average Number of Rides") +
  work_theme

# Creating a bar graph to represent the average trip duration per days of the week
processed_data %>%
  group_by(week_day, member_casual) %>% 
  summarise(mean_duration = mean(trip_duration)) %>% 
  ggplot(mapping = aes(x = week_day, y = mean_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Member vs. Casual Trip duration over a week",
       x = "Days of the week",
       y = "Trip duration in minutes") +
  work_theme +
  scale_fill_brewer(palette = "Dark2")


# Creating a bar graph to represent the number of rides over the year
processed_data %>%
  mutate(member_casual = fct_relevel(member_casual, "member", "casual"))  %>% 
  count(week, member_casual) %>% 
  ggplot(mapping = aes(x = week, y = n, fill = member_casual)) +
  geom_area(alpha = 0.6, color = 2, position = position_dodge(width=0)) +
  labs(title = "Member vs. Casual Rides over a Year",
       x = "Months",
       y = "Number of Rides") +
  scale_x_continuous(breaks = seq(from = 2, to = 52, by = 4.5),
                     labels=c('Jan','Feb','Mar','Apr','May','Jun',
                              'Jul','Aug','Sep','Oct','Nov','Dec')) +
  scale_fill_manual(values = c("member" = "#00BFC4", "casual" = "#F8766D")) +
  work_theme

# Creating a bar graph to represent the average trip duration over the year
processed_data %>% 
  group_by(week, member_casual) %>% 
  summarise(mean_duration = mean(trip_duration)) %>% 
  ggplot(mapping = aes(x = week, y = mean_duration, fill = member_casual)) +
  scale_color_brewer(palette = "Dark2") +
  geom_area(alpha = 0.6, color = 2, position = position_dodge(width=0)) +
  labs(title = "Member vs. Casual Trip duration over the year",
       x = "Month of the year",
       y = "Trip duration in minutes") +
  scale_x_continuous(breaks = seq(from = 2, to = 52, by = 4.5),
                     labels=c('Jan','Feb','Mar','Apr','May','Jun',
                              'Jul','Aug','Sep','Oct','Nov','Dec')) +
  work_theme +
  scale_fill_brewer(palette = "Dark2")

# Creating a datasets to work with in the Tableau software
ride_count <- processed_data %>%
  count(start_lat, start_lng, member_casual, rideable_type)

ride_duration <- processed_data %>% 
  group_by(start_lat, start_lng, member_casual) %>% 
  summarise(mean_duration = round(mean(trip_duration)))

ride_distance <- processed_data %>% 
  group_by(start_lat, start_lng, member_casual) %>% 
  summarise(mean_distance = round(mean(distance)))

write.csv(ride_count, file = "./Output/Data/ride_count.csv", row.names = FALSE)
write.csv(ride_duration, file = "./Output/Data/ride_duration.csv", row.names = FALSE)
write.csv(ride_distance, file = "./Output/Data/ride_distance.csv", row.names = FALSE)