# Queries for Clustering Exercises

# let's look at initial transactions in 2017 from both housing tables
SELECT *
FROM properties_2017 AS p17
LEFT JOIN predictions_2017 USING(parcelid)
RIGHT JOIN properties_2016 USING(parcelid);
# 2,985,417

# how many nulls do we have in lat long?
SELECT *
FROM properties_2017 AS p17
LEFT JOIN predictions_2017 USING(parcelid)
RIGHT JOIN properties_2016 USING(parcelid)
WHERE p17.latitude IS NULL
OR p17.longitude IS NULL;
# 2,933


# 2016 properties that have transactions in 2017
SELECT *
FROM properties_2016
LEFT JOIN predictions_2017 USING(parcelid)
WHERE transactiondate LIKE '2017%';
# 77K rows


# take out the nulls for both
SELECT *
FROM properties_2017 AS prop17
LEFT JOIN predictions_2017 USING(parcelid)
RIGHT JOIN properties_2016 USING(parcelid)
LEFT JOIN airconditioningtype ON prop17.airconditioningtypeid = airconditioningtype.airconditioningtypeid
WHERE prop17.latitude IS NOT NULL
OR prop17.longitude IS NOT NULL;
# 2,982,285


# now let's join everything
SELECT *
FROM predictions_2017
JOIN properties_2017 USING (parcelid)
LEFT JOIN airconditioningtype USING (airconditioningtypeid)
LEFT JOIN architecturalstyletype USING (architecturalstyletypeid)
LEFT JOIN buildingclasstype USING (buildingclasstypeid)
LEFT JOIN heatingorsystemtype USING (heatingorsystemtypeid)
LEFT JOIN propertylandusetype USING (propertylandusetypeid)
LEFT JOIN storytype USING (storytypeid)
LEFT JOIN typeconstructiontype USING (typeconstructiontypeid)
WHERE properties_2017.latitude IS NOT NULL
OR properties_2017.longitude IS NOT NULL;
# 77580



# Switch up how we use the joins so we can add in a subquery to use only the latest transactions for homes with duplicate sales. I chose to leave out the 2016 properties for now
SELECT *
FROM properties_2017
INNER JOIN (SELECT parcelid,
       					  logerror,
                          Max(transactiondate) AS transactiondate 
                        FROM   predictions_2017 
                        GROUP  BY parcelid, logerror) pred USING (parcelid)
LEFT JOIN airconditioningtype USING (airconditioningtypeid)
LEFT JOIN architecturalstyletype USING (architecturalstyletypeid)
LEFT JOIN buildingclasstype USING (buildingclasstypeid)
LEFT JOIN heatingorsystemtype USING (heatingorsystemtypeid)
LEFT JOIN propertylandusetype USING (propertylandusetypeid)
LEFT JOIN storytype USING (storytypeid)
LEFT JOIN typeconstructiontype USING (typeconstructiontypeid)
WHERE properties_2017.latitude IS NOT NULL
OR properties_2017.longitude IS NOT NULL;
# 77,575




