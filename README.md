# HerkyAsks

HerkyAsks is an Android and iOS application written in Flutter that will be used to perform and gather CSUS student surveys and survey results. 
The app will be connected to the Firebase Database to retrieve user survey results in JSON format and then using Google Sheets API, 
results will be converted into an excel format which will be stored in OIR department database (final format can be changed).
As of now, there will be two versions of the app, for the admin and for the regular users.


## Breakdown

### User Side
1. CSUS studens will be able to register for the app only using their email that has an "@csus.edu" extension at the end. When registered, 
the app will use Firebase Authorization to securely store user login information and generate a unique token for each user.
2. After registering, users will be presented with a scrollable list of available surveys to take. Also, the side menu will allow each user
to see their past activities.
3. When user takes a survey, they will be taken to a different screen where they will be presented with one question at a time. When user
completes a question, they can click next or swipe to go the next question. To keep track of the progress, there will be a progress bar
to keep track of remaining number of questions.
4. Also, not decided yet, but each user might be rewarded with something at the end of the survey
5. Whenever a new survey is uploaded, users will get a notification on their devices
### Admin Side
1. The admin side at the moments is not completelly decided yet as it can be performed through computer rather than an app. Need to think
about this more.
#### Desktop Version
2. The admin will be able to upload an excel or json document with survey questions into a firebase database. From there, admin will set the
value called is_active to true, so that way user side will trigger and get the new question on their app. I will provide a detailed breakdown of performing described process later on.
#### App Version
2. Admin will be able to write questions through textbox and available options through add more button and then click on upload and set active time for the survey.

## Technology

### [Flutter](http://flutter.dev/)
Flutter is a cross platform language made by Google that allows writing a single code for logic for multiple platforms and then write
a separate UI code for each platform. Flutter removes the need for writing two separate native codes for each platform so it should
speed up the process
### [Firebase](https://firebase.google.com/)
Firebase Authorization and Database is integrated with Flutter, so this was a first choice to use for user registration and user 
credentials as well as storing user survey results

## Suggestions
For suggestions, you can head to "Issues" tab and open a new issue
## Authors

* **Yunus Kulyyev** - [Graspery](https://play.google.com/store/apps/dev?id=8637816620025557781&hl=en_US)
