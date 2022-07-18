USE StudentGradeManagement
GO

--Query to query the DBI202 FE Score of students and arrange them--
--Use Order By, INNER JOIN, GROUP BY and HAVING clauses
SELECT s.StudentID, s.StudentName, sa.AssessmentID, sa.Score FROM
Student_Assessment sa INNER JOIN Student s ON sa.StudentID = s.StudentID
GROUP BY s.StudentName, s.StudentID, sa.AssessmentID, sa.Score
HAVING sa.AssessmentID = 'DBI202 FE'
ORDER BY Score DESC
GO

--Query to query the number of absent session of the student
--Use aggregate function--

SELECT s.StudentName, COUNT(s.StudentName)
FROM Student s INNER JOIN Attendance a ON s.StudentID = a.StudentID
GROUP BY s.StudentName, a.Status
HAVING a.Status = 0
GO

--Query to check the attendance of the student whose first name is Nguyen and DBI202 PE Score is 10
--Use sub-query and partial matching 
SELECT *
FROM Student s INNER JOIN Attendance a ON s.StudentID = a.StudentID
WHERE s.StudentID IN (
SELECT s.StudentID FROM
Student_Assessment sa INNER JOIN Student s ON sa.StudentID = s.StudentID
WHERE sa.Score = 10 AND sa.AssessmentID = 'DBI202 PE' ) AND StudentName LIKE 'Nguyen%'
GO

--Store procedure to calculate the averrage score of student--

CREATE PROCEDURE CalculateAverrageScore AS
SELECT s.StudentName, SUM(sa.Score * a.Weight)/2
FROM Assessment a INNER JOIN Student_Assessment sa ON a.AssessmentID = sa.AssessmentID
				INNER JOIN Student s ON s.StudentID = sa.StudentID
GROUP BY s.StudentName
GO

EXEC CalculateAverrageScore
GO

--Trigger to check that student only study in 1 DBI Class
CREATE TRIGGER tên_trigger ON Enroll
AFTER INSERT,UPDATE,DELETE
AS
	DECLARE @ClassID VARCHAR(20);
	DECLARE @StudentID VARCHAR(10);
	SELECT @StudentID = StudentID FROM inserted;
	SELECT @ClassID = ClassID FROM Enroll WHERE @StudentID = StudentID AND ClassID LIKE '%DBI202';
	IF @ClassID IS NOT NULL
	BEGIN
		PRINT 'Student joined enough class';
		ROLLBACK TRAN
	END
GO

INSERT INTO Enroll VALUES('SE1602 DBI202', 'HE000001')
GO