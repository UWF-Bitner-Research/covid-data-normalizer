# COT 6931 - Zach Pope

## Hypotheses
- Does mask-wearing actually cause a surge of cases due to people being more comfortable with close interactions
- Establish the "lag" between mandate and cases slowing/dropping

## Ideas
- Create comprehensive, integrated data source, which includes structured data related to control measures by region (municipality, county, or state - as available).
- Create heat map of the US indicating deaths from Covid (perhaps use total deaths to avoid politicization concerns over whether a death was _really_ from Covid).
- Create other visualizations to establish and compare periodicity in the data (such as flu seasonality, etc).
	- Google Charts - https://developers.google.com/chart
	- VB.net chart tools - https://www.c-sharpcorner.com/UploadFile/a80666/how-to-use-chart-control-in-VB-Net-2010/

## Helpful links
- IHME data visualization - https://covid19.healthdata.org/united-states-of-america
- Heatmap
- Johns Hopkins map - https://coronavirus.jhu.edu/us-map
	- Dataset on GitHub - https://github.com/CSSEGISandData/COVID-19

## Data sources
- CDC: 2014-2019 https://data.cdc.gov/NCHS/Weekly-Counts-of-Deaths-by-State-and-Select-Causes/3yf8-kanr
- CDC: 2020-2021 https://data.cdc.gov/NCHS/Weekly-Counts-of-Deaths-by-State-and-Select-Causes/muzy-jte6
- CDC: 2020-2021 COVID cases by state https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36
- Control measures
	- Mask mandates ??
	- School closures ??
	- Curfews ??
- Hospitals per capita or other things that might impact the survival rate of patients.
- Voting records, if a correlation between political leanings and control measures is of interest.
- https://github.com/USCOVIDpolicy/COVID-19-US-State-Policy-Database

## Tech stack options
- Heroku with .net - https://codersblock.com/blog/how-to-run-net-on-heroku/
- Possibly something equivalent for AWS free tier
- Preferred DBMS?? MySQL is generally a great option but might not be easy to use on free tier (Heroku) and PostgreSQL might be needed.
	- Does VB.net work more readily with on over the other?
	- Is there a VB.net PDO-style DB wrapper class that allows for the DBMS to be swapped out?

# Plan
1. Conduct background literature review to see what has already been done.
	1. Write literature review section 2+ pages, summarizing existing work
1. Identify gaps in existing analyses
	1. Describe plan to _close the gap_.
1. Develop tool to meet the stated aim.
	- Most likely will require a server cron job to pull in data daily and update the DB tables.
	- Possibly it is a data aggregator service that gives statisticians access to _clean_ data for analysis.
	- Possibly charts of data showing periodicity of data, or correlation between metrics.
		- The user should be able to select data fields of interest to filter.
	- Possibly GIS polygonal overlay using OpenStreetMap or other open source mapping tool showing heat map at the desired (available) region size.
1. Covid Policy dataset normalization script and BCNF or higher DB schema.

# This Repository
- [related-literature](related-literature) - houses the fulltext PDF versions of the background investigation.
- [research-paper](research-paper/) - This is the files associated with the paper written for this project.
	- Inside this directory is a Makefile that can be used to compile the LaTeX document into a well-formatted PDF.
		- Simply type `make` at the command line inside this directory and the paper will compile.
		- If doing so on the SSH server, you'll need to transfer the main.pdf file back to your machine to view it.
	- Only two files need to be edited:
		1. [research-paper/content.tex](research-paper/content.tex) - This is the actual content of the paper that is written
		1. [research-paper/main.bib](research-paper/main.bib) - This is a database in Bibtex format used to generate the references section of the completed paper.
		Entries are easily exported from the various portals used for finding related reseach papers.
		Look for **citation**, or **export** or something to that effect to find the option to export to bibtex.
			- To reference the sample paper below, one would type `Einstein wasn't just smart, he was bi-lingual~cite{einst1234}.`
			```bibtex
			@article{einst1234,
				author = {Albert Einstein},
				title = {{Zur Elektrodynamik bewegter K{\"o}rper}. ({German})
				[{On} the electrodynamics of moving bodies]},
				journal = {Annalen der Physik},
				volume = {322},
				number = {10},
				pages = {891--921},
				year = {1905},
				DOI = {http://dx.doi.org/10.1002/andp.19053221004},
				keywords = {physics}
			}
			```
