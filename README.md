<a id="readme-top"></a>

<!--
*** This README is built upon the Best-README-Template, created by Othneil Drew.
*** If you wish to use this template, go check his repository :
*** https://github.com/othneildrew/Best-README-Template/tree/master
*** And don't forget to give his project a star!
-->

<!-- PROJECT TITLE -->

<div align="center">
  <a href="https://rpubs.com/G_Wartelle/divvy-bikes-case-study">
    <img src="./Assets/bars-graph-svgrepo-com.svg" alt="Data Analysis Logo"  height="70">
  </a>
</div>
<h1 align="center">Divvy Bikes Case Study</h1>

<!-- TABLE OF CONTENTS -->

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#folder-structure">Folder Structure</a></li>
    <li><a href="#cloning-the-project">Cloning the project</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#modifications">Modifications</a></li>
    <li><a href="#improvements">Improvements</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

<h2 id="about-the-project">About The Project</h2>

![Circular Diagram Screenshot](./Assets/circular_diag.png)

If you want to take a direct look at this data analysis, you can do so by checking right [here](https://rpubs.com/G_Wartelle/divvy-bikes-case-study).

It is hosted on [RPubs](https://rpubs.com/), a service provided by RStudio, where users can publish their R Markdown documents online.

This is a case study focusing on the DivvyBikes rental service.
I conducted this analysis to apply the skills I acquired through the Google Data Analytics Certificate program hosted on [Coursera](https://www.coursera.org/professional-certificates/google-data-analytics).
The main objective of this study was to identify differences between members and casual users and propose strategies to boost subscription rates for Divvy services.

The analysis was done using [R](https://www.r-project.org/), a statistical computing programming language.
The main library used to make this analysis is [Tidyverse](https://www.tidyverse.org/), as this library has all the necessary tools for data science.
The other libraries used for this project are [skimr](https://cran.r-project.org/web/packages/skimr/vignettes/skimr.html) for summarizing data, [RANN](https://cran.r-project.org/web/packages/RANN/index.html) used for fiding the closest station to a user, [patchwork](https://cran.r-project.org/web/packages/patchwork/index.html) for organizing some plots, [RColorBrewer](https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3) for different color palettes for plots, and [tibble](https://cran.r-project.org/web/packages/tibble/index.html) for data frames.

Aside from a programming language, I used two other tools for this study.
The first one I used is [Google My Maps](https://www.google.com/maps/d/?hl=en) to create a map of the users' favorite stations.
And the second one, is [Tableau](https://www.tableau.com/), for creating the heatmaps at the end of the analysis.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FOLDER STRUCTURE -->

<h2 id="folder-structure">Folder Structure</h2>

In the root of the project, the main file is `CompteRendu.Rmd` as this is the final result of the analysis and is the file hosted on RPubs.
There's also `CompteRendu.html` which is the same file but as a HTML file.
After this, you have this `README.md` file, a `.gitignore` file, a `.Rhistory` file, and `DivvyBikesCaseStudy.Rproj` for configuration.

The rest is organised in folders :

- `Assets/` has the images used for this `README.md` file
- `Data/` has the data used for this study in two folders. First in `Chicago Shapefile/` there is the data used for the heatmaps, and `Study Data/` is where the .csv files used for the study are supposed to go
- `Document/` has the presentation of the case study
- `Output/` has the data created during this analysis, also in two different folders. In `Data/` there are the .rds file with the cleaned data, and the .csv files used to create the heatmaps using [Tableau](https://www.tableau.com/). And in `Maps/` there are the maps created for this study
- The `rsconnect/` folder was created for uploading this analysis on [RPubs](https://rpubs.com/)
- And the `Script/` has the main [R](https://www.r-project.org/) script used to perform the analysis

That's it for the folder structure !

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CLONING THE PROJECT -->

<h2 id="cloning-the-project">Cloning the project</h2>

If you want to clone this project you just need [Git](https://git-scm.com/downloads).

1. To clone this project, first go in the directory you want to install the project in :

   ```sh
   cd path/to/your/directory
   ```

2. And then run this command to clone the project :

   ```sh
   git clone https://github.com/GWartelle/DivvyBikesCaseStudy.git
   ```

<!-- USAGE EXAMPLES -->

<h2 id="usage">Usage</h2>

Once the project is cloned, if you want to replicate this analysis, the first thing you have to do is to download the .csv files used for this study.
You can do so right [here](https://divvy-tripdata.s3.amazonaws.com/index.html).

This study was done using the data of a full year, so invite you to download the twelve latest .csv files, as they are organised by month. 

![Divvy Bikes Data Screenshot](./Assets/divvy_data.png)

Once you downloaded the necessary files, you must put them in the `Data/Study Data/` folder, otherwise the script won't work correctly.

And when this is done, you only have to open the `DivvyBikesDataAnalysis.R` script in your editor and run it.

Normally this should work on any modern IDE, but I would recommend using either [RStudio](https://posit.co/) (now called posit), or [Jupyter](https://jupyter.org/), as these will allow you to easily run the script one chunk of code at a time.

![Sociopedia Home Page Screenshot](./public/assets/home_screen.png)

Once logged in, you'll land on the home page.
To make things clear, this web app has a lot of mockup features.
This is intentional as this leaves the opportunity to implement a lot of new things once the tutorial is finished.

So, now that this is out of the way, let's dive into this home page.
At the top of the screen we have the navigation bar, with a search bar on the left.
This is the first mockup feature, as you can enter some text into the search bar, but clicking the search icon won't do anything.
This would be the opportunity to implement a profile searching feature.

On the right side we have the name of the user in a select menu, with the options of logging out and deleting the account.
Besides that, the message, notification, and help icons are also mockup features, open for implementation.
But the sun icon does work, as it toggles the dark mode on.

![Sociopedia Dark Mode Screenshot](./public/assets/dark_screen.png)

On the main page we found mutiple panels.
On the left, there is the `User` panel, with all your info.
Here there are some mockup features too: the account parameters icon and the social profiles are here for demonstration sake.
And the views and impressions numbers are randomly generated at the creation of your profile.

In the center of the screen, we find the feed, with the `MyPost` panel at the top.
This panel allows you to enter a message to post on the feed for all the other users to see.
You also have the possibility to send an image along with your message, by cliking on the image option, which pops off a dropzone where you can drag your image in.
As for the other options (Clip, Attachment and Audio), those are mockup features as well.

On the feed of Sociopedia, you can see all the other users' posts.
On the top right of every posts (except yours), there is an add-friend icon which adds the creator of this post to your friend list.
At the bottom of each post panel you have a heart icon for liking the post, and a comment icon for opening the comment section.
For now you can only find mockup comments in this section, as the comment feature is not implemented yet.

On the right of the screen there's an `Advertisement` panel, which is also a mockup feature.
And finally under this panel, you have the `FriendList` panel, with all of your friends, with a remove-friend icon on their right if you want to remove them from the list.

Speaking of friends, if you click on a user's name, you are redirected to his/her profile page.

![Sociopedia Profile Page Screenshot](./public/assets/profile_screen.png)

On the top left of this page, you can find the `User` panel once again, but with the info of the user you cliked on this time.
Under this panel, there is also the `FriendList` panel, but only with the friends of this user.

On the center of the screen, there is also a feed, but this one only contains the posts of the user of this profile page.

Lastly, if you want to get back to the home page, you can simply click on the `Sociopedia` logo in the top left of the screen. And if you want to log out (or delete your account), you can do so by clicking the select menu with your username in the top right of the screen.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MODIFICATIONS -->

<h2 id="modifications">Modifications</h2>

Compared to the original project, I changed some things here and there: I added a delete user account feature, I removed the possibility to add yourself to your own friend list, I also removed the possibility to create a post from the profile page of a user, etc ...

But one major thing I added to this project is the storage of uploaded images in an AWS S3 bucket, instead of storing them directly on the server. I decided to implement this feature because I deployed this project on Render, and the ability to store files on it is rather limited, as its file system is ephemeral.

So I wanted to share with you how I managed to implement this cloud storage.
Of course the first part was to create an AWS account, create a new S3 bucket, and put all its credentials in my .env file.

Once this was done, it was time to set this up on my server :

```js
/* AWS SDK SET UP */
const s3 = new S3Client({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

/* FILE STORAGE */
const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: process.env.AWS_BUCKET_NAME,
    contentType: multerS3.AUTO_CONTENT_TYPE,
    key: function (req, file, cb) {
      const filename = file.originalname
        .replace(/\s+/g, "-")
        .replace(/[^\w.-]+/g, "");
      cb(null, Date.now().toString() + "-" + filename);
    },
  }),
});

/* ROUTES WITH FILES */
app.post("/auth/register", upload.single("picture"), register);
app.post("/posts", verifyToken, upload.single("picture"), createPost);
```

The first thing to do was to create a S3Client, using the credentials of the bucket.

Next it was time to create the function `upload` for uploading files in the bucket.
Multer, as this is the tool used for uploads in this project, uses the S3Client I just set up `s3`, and connects with my bucket using the `AWS_BUCKET_NAME` stored in my .env file.

And then Multer creates a `key` to identify the uploaded file, by combining the current date in Unix time with the name of the file without spaces or special characters.

This function is then called as a middleware in the `register` and `posts` routes, before the `register` and `createPost` controllers as they are the only ones with the image upload feature.

Talking about these controllers, here is how they look like :

```js
/* REGISTER USER */
export const register = async (req, res) => {
  try {
    /* ... */
    const picturePath = req.file.location;

    const newUser = new User({
      /* ... */
      picturePath,
      /* ... */
    });
    const savedUser = await newUser.save();
    res.status(201).json(savedUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

/* CREATE POST */
export const createPost = async (req, res) => {
  try {
    /* ... */
    let picturePath;

    if (req.file) {
      picturePath = req.file.location;
    }

    const newPost = new Post({
      /* ... */
      picturePath,
      /* ... */
    });
    await newPost.save();

    const post = await Post.find();
    res.status(201).json(post);
  } catch (err) {
    res.status(409).json({ message: err.message });
  }
};
```

To simplify things here, I just kept the `picturePath` field in these MongoDB documents.

As you can see, the `register` and `createPost` controllers are both getting the image URL with `req.file.location`, which is then stored in the database.

But aside from storing uploaded images in this S3 bucket, I also had to implement how to delete them from the bucket if the user deletes his/her account.

```js
const s3 = new S3Client({
  region: process.env.AWS_REGION,
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  },
});

function getKeyFromUrl(url) {
  const index = url.lastIndexOf("/");
  return url.substring(index + 1);
}

async function deleteImageFromS3(imageUrl) {
  try {
    const imageKey = getKeyFromUrl(imageUrl);

    const deleteParams = {
      Bucket: process.env.AWS_BUCKET_NAME,
      Key: imageKey,
    };

    const deleteCommand = new DeleteObjectCommand(deleteParams);
    await s3.send(deleteCommand);

    console.log(`Image with key ${imageKey} deleted from S3 bucket.`);
  } catch (err) {
    console.error(`Error deleting image with key ${imageKey}: ${err.message}`);
  }
}
```

First I had to set a new S3Client, because this is in another file, as implementing this function directly in the main file of the server would have been too cumbersome.

Next I created a `getKeyFromUrl` function that extracts the key of an image to delete based on its URL by removing everything before the last `/`.

Then comes the `deleteImageFromS3` function which takes the URL of an image, extracts its key using `getKeyFromUrl`, sets up the parameters of the deletion with the name of the bucket and the key of the image, and then sends a `DeleteObjectCommand` with these parameters.

The last thing to do is to use this `deleteImageFromS3` function in the `deleteUser` controller:

```js
/* DELETE USER */
export const deleteUser = async (req, res) => {
  try {
    const userId = req.params.userId;

    // Find the user in the database and get their profile picture URL
    const user = await User.findById(userId);
    const profilePictureUrl = user.picturePath;

    // Delete the user's profile picture from the bucket
    await deleteImageFromS3(profilePictureUrl);

    // Get the user's posts and their image URLs
    const posts = await Post.find({ userId });
    const imageUrls = posts.map((post) => post.picturePath);

    // Delete the posts images from the bucket
    for (const imageUrl of imageUrls) {
      if (imageUrl) {
        await deleteImageFromS3(imageUrl);
      }
    }

    // Delete the user's posts
    await Post.deleteMany({ userId });

    // Delete the user from other users' friend list
    await User.updateMany({}, { $pull: { friends: userId } }, { multi: true });

    // Delete the user from the database
    await User.findByIdAndDelete(userId);

    res.status(200).json({ msg: "User deleted successfully." });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
```

After getting the `userId` from the request, this controller first finds the user in the database, gets the URL of his/her profile picture and then deletes it with `deleteImageFromS3`.

The next thing to do is to get all the posts this user made, and then map the image's URL of each of these posts to an `imageUrls` variable.
After this, the controller loops over each `imageUrl` in `imageUrls` and deletes it from the bucket if it exists (as it is possible to create a post without an image), using `deleteImageFromS3` once again.

Finally, the controller just needs to update the MongoDB database by deleting all the posts of the user, removing him/her from the friend list of all the other users, and then deleting his/her profile.

And this is how I implemented an AWS cloud storage for my web app !

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<h2 id="improvements">Improvements</h2>

As mentioned multiple times in the [usage](#usage) section, this project leaves room for a lot of features to be built.
Therefore, if I had more time on my hands to improve this web app, here are the features I would implement :

1. I'd start by implementing a password confirmation to the register page, and I'd also add a password retrieval feature, as these are staples of all modern apps.
2. Really implementing the commenting feature is a must have. Being able to comment other users' posts is a crucial part of every other social medias.
3. Then, I would upgrade the friend list feature. Instead of being able to add anyone as a friend, the user should first have to send a friend request.
4. Even if it'd represent a lot of work, it would be great to implement the instant messaging system. Based on the improved friend list, users could send private messages to their friends.
5. With the comments properly implemented, the improved friend list, and the private messages, a nice feature to complement all of this would be notifications. Users could know when one of their friends creates a new post, when someone comments one of their own posts and when they receive a new message.
6. Finally, even if uploading images could be enough, it'd be nice to also have videos and audios uploads for posts.

After that, this project could benefit from a lot of other changes like being able to update the user account, having real counts of views and impressions, adding the date and time to posts, really implementing the search bar, having the option for users to change/delete their posts, or being able to create an account using google, apple or other credentials, but I think this should be enough to begin with.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

<h2 id="contact">Contact</h2>

If you want to see more of my work, I invite you to go check my [portfolio](https://gwartelle.github.io/MyPortfolio/).

You can also take a look at my other projects on my [github](https://github.com/GWartelle).

And if you'd like to get in touch with me, feel free to reach out on [LinkedIn](https://www.linkedin.com/in/gabriel-wartelle/).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->

<h2 id="acknowledgments">Acknowledgments</h2>

As mentionned above, this project was made following this [tutorial](https://www.youtube.com/watch?v=K8YELRmUb5o).
So I would like to thank its creator for his amazing work.
If you want to go check the github of his tutorial you can do so right [here](https://github.com/ed-roh/mern-social-media).
Feel free to give him a star, as his work was well structured and his explanations clear and useful.

And of course I would like to thank you for taking the time to read through all this !
I wish you the best 😁

Have a great day 😉

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

<h2 id="license">License</h2>

Distributed under the MIT License. See [opensource.org](https://opensource.org/license/mit) for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
