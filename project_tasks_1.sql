SELECT * FROM books;

SELECT * FROM branch;

SELECT * FROM employees;

SELECT * FROM issued_status;

SELECT * FROM return_status;

SELECT * FROM members;

-- Solving each project tasks one by one.

--Task 1. Create a New Book Record -->"978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;


--Task 2: Update an Existing Member's Address
UPDATE members 
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;


--Task 3: Delete a Record from the Issued Status Table --> Delete the record with issue_id = 'IS121' from the issued_status table
DELETE FROM issued_status
WHERE issued_id = 'IS121';
SELECT * FROM issued_status;


--Task 4: Retrieve All Books Issued by a Specific Employee -->Select all books issued by the employee with emp_id = 'E101'
SELECT * FROM issued_status;
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


--Task 5: List Members Who Have Issued More Than One Book --> Use GROUP BY to find members who have issued more than one book.
SELECT 
	issued_emp_id,
	COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1


-- CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE book_cnts
AS
SELECT 
	b.isbn,b.book_title,
	COUNT(ist.issued_id) AS no_of_issued
FROM books AS b
JOIN
issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn,b.book_title;

-- SELECT EVERYTHING FROM THE CREATED TABLE book_cnts
SELECT * FROM book_cnts;


-- Data Analysis and Findings
-- Task 7. Retrieve All Books in a Specific Category
SELECT * FROM books
WHERE category = 'Classic';


-- Task 8: Find Total Rental Income by Category
SELECT
	b.category,
	SUM(b.rental_price),
	COUNT(*)
FROM books AS b
JOIN
issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;


-- Task 9: List Members Who Registered in the Last 180 Days

-- First let's insert the values which are registered in the last 180 days as we are not having those type of records
INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C120', 'sammy', '145 Main St', '2025-06-01'),
('C121', 'johnny', '133 Main St', '2025-05-01');

SELECT * FROM members
WHERE AGE(reg_date) <= '180 days' ;


-- Task 10: List Employees with Their Branch Manager's Name and their branch details.
SELECT 
	e1.*,
	b.manager_id,
	e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b
ON b.branch_id = e1.branch_id
JOIN 
employees AS e2
ON b.manager_id = e2.emp_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD
CREATE TABLE books_price_greater_than_seven AS
SELECT * FROM books
WHERE rental_price > 7.00;

-- retrieving the books information from the above created table books_price_greater_than_seven
SELECT * FROM books_price_greater_than_seven;


-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT * from return_status;

SELECT 
DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;



