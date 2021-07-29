<?php
	// in practice, here I'd connect to the DB
	// $dbh = new DatabaseConnectionClient(...);

	// Then, query for the data
	// $dbh->query("SELECT year, sales, expenses FROM table1 WHERE foo=\"Bar\" LIMIT 20");

	// Set up the JSON
	// echo "var data = google.visualization.arrayToDataTable([

	// Print header
    // echo "['Year', 'Sales', 'Expenses'],";

	// Grab each DB row and print out the data
	// foreach ($dbh->fetch() as $result)
	// {
	//     echo "['" . $result['year'] . "', '" . $result['sales'] . "', '" . $result['expenses'] . "],";
	// }

	// print out the end of the JSON closing bracket
	// echo "]);";


	// The effect of the above would basically be the following, assuming that the data in the DB matched this
	echo "var data = google.visualization.arrayToDataTable([
          ['Year', 'Sales', 'Expenses'],
          ['2004',  100,      400],
          ['2005',  1170,      460],
          ['2006',  660,       1120],
          ['2007',  1030,      540]
        ]);";
