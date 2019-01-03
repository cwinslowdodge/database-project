-- Q1
SELECT serialNum, customerID
FROM Computer c, Customer cst, Purchased p, Manufacturer_Region mfr
WHERE p.serialNum == c.serialNum AND
      cst.CID = p.CID AND
      c.manufacturer == mfr.name AND
      mfr.region == c.region;
-------------------------------------
-- Q2
SELECT DISTINCT c1.serialNum, c2.serialNum
FROM computer c1, computer c2
WHERE c1.msrp = c2.msrp AND
      c1.serialNum < c2.serialNum;
--------------------------------------
-- Q3.1
SELECT *
FROM Computer c, Operating_System os
WHERE c.osID = os.osID AND os.name IS LIKE ‘Windows 8.1’
UNION
SELECT *
FROM Computer c, Operating_System os
WHERE c.osID = os.osID AND os.name IS LIKE ‘Windows 7’;
---------------------------------------
-- Q3.2
SELECT c.serialNum
FROM Computer c
INTERSECT
SELECT p.serialNum
FROM Purchased p
WHERE payment_method like ‘creditcard’;
---------------------------------------
-- Q3.3
SELECT p.serialNum
FROM Purchased p
MINUS
SELECT c.serialNum
FROM Computer c, Operating_System os
WHERE c.osID = os.osID AND os.name is like ‘Windows10’;
---------------------------------------
-- Q4
SELECT sum(amount), AVG(amount), max(amount), min(amount)
FROM Purchased p;
---------------------------------------
-- Q5
SELECT c.ram, count(*)
FROM Computer c
WHERE c.ram >=8
GROUP BY c.ram
HAVING COUNT >=2
ORDER BY c.ram;
---------------------------------------
-- Q6
SELECT c.serialNum, c.manufacturer, c.model
FROM computer c
WHERE c.serialNum NOT IN
		(SELECT p.serialNum
		FROM purchased p
		WHERE c.serialNum = p.serialNum)
		ORDER BY c.serialNum;
---------------------------------------
-- Q7
SELECT c.serialNum, c.model, c.MSRP
FROM (SELECT *
	FROM Computer c
	ORDER BY c.MSRP, desc)
    WHERE ROWNUM <= 1;
---------------------------------------
-- Q8
SELECT *
FROM Customer cst
WHERE NOT EXISTS (SELECT os.osID
                  FROM Operating_System os
                  WHERE os.name IS LIKE 'Windows%')
                  MINUS
                  (SELECT c.osID
                  FROM Purchased p, Computer c
                  WHERE c.customerID = p.customerID AND
                  p.serialNum = c.serialNum));
---------------------------------------
-- Q9
SELECT c.serialNum, c.manufacturer, c.model
FROM Computer c, LEFT OUTER JOIN Purchased p ON c.serialNum = p.serialNum;
---------------------------------------
