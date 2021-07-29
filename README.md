# Zachary Pope and Steven Bitner
zap6@students.uwf.edu
sbitner@uwf.edu

## Data sources
- https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36
- https://github.com/USCOVIDpolicy/COVID-19-US-State-Policy-Database

## Explanation of Repository
Inside the code folder you'll find the code that was used to run this application. 
There are two solutions: one to extract data from the files and insert into the database, and one to read data from the database and present it in charts.
You will need to update the app.config file in the extraction solution to include your DB login information in order to use
You will need to update the web.config file in the presentation solution to include your DB login information in order to use
Inside the database folder, you'll find the scripts used to create all tables and procs necessary to use the application
The datasources folder contains examples of what files you should use, using the datasources above
The datasources files are likely out of date - you can use them for testing, but for serious analysis you should update with the latest data from the above links.
