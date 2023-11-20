DROP PROCEDURE IF EXISTS dbo.EnterNewCustomer
DROP PROCEDURE IF EXISTS dbo.EnterNewDepartment;
DROP PROCEDURE IF EXISTS dbo.EnterNewProcess;
DROP PROCEDURE IF EXISTS dbo.createaccount;
DROP PROCEDURE IF EXISTS dbo.NewAssembly;
DROP PROCEDURE IF EXISTS dbo.EnterNewJob;
DROP PROCEDURE IF EXISTS dbo.enterTransactionNum;
DROP PROCEDURE IF EXISTS dbo.updateJob;
DROP PROCEDURE IF EXISTS dbo.GetTotalCostForAssembly;
DROP PROCEDURE IF EXISTS dbo.GetCustomersByCategoryRange;
DROP PROCEDURE IF EXISTS dbo.DeleteCutJobsByJobNoRange;
DROP PROCEDURE IF EXISTS dbo.ChangePaintJobColor;
DROP PROCEDURE IF EXISTS dbo.GetTotalLaborTime;
DROP PROCEDURE IF EXISTS dbo.GetProcessDepartmentDetails;
DROP PROCEDURE IF EXISTS dbo.InsertJobData;



---------------------------------------- 1.  Create the procedure for InsertNewCustomer----------------------------------------
GO
CREATE PROCEDURE EnterNewCustomer
    @new_customer_name NVARCHAR(255),
    @new_customer_address NVARCHAR(255),
    @new_category INT
AS
BEGIN
    INSERT INTO Customer (customer_name, customer_address, category)
    VALUES (@new_customer_name, @new_customer_address, @new_category);
END;

---------------------------------------------2.Enter a new department-------------------------------------------------------------------------
GO
CREATE PROCEDURE EnterNewDepartment
    @new_department_num INT,
    @new_department_data NVARCHAR(255)
AS
BEGIN
    -- Insert the new department without checking for duplicates
    INSERT INTO department (department_num, department_data)
    VALUES (@new_department_num, @new_department_data);
END;

------------------------------------------3.Enter a new process-id and its department together with its type and information relevant to the type-----------------`
GO
CREATE PROCEDURE EnterNewProcess
    @process_id INT,
    @department_num INT,
    @process_type VARCHAR(255),
    @process_info VARCHAR(255),
    @machine_type VARCHAR(255) ,
    @cutting_type VARCHAR(255),
    @painting_method VARCHAR(255),
    @paint_type VARCHAR(255),
    @process_data VARCHAR(255)
AS
BEGIN
    -- Check if the process and department exist
    IF EXISTS (SELECT 1 FROM Processes WHERE process_id = @process_id) AND
       EXISTS (SELECT 1 FROM Department WHERE department_num = @department_num)
    BEGIN
        PRINT 'Process and department already exist.';
        RETURN;
    END
    ---Insert into the process table
    INSERT INTO Processes(process_id,process_data)
    VALUES(@process_id, @process_data)

    -- Insert the new process information into the Supervised table
    INSERT INTO Supervised (process_id, department_num)
    VALUES (@process_id, @department_num);

    -- Insert the process details into the respective table based on the type
    IF @process_type = 'Cut'
    BEGIN
        INSERT INTO Cut (process_id, cutting_type, machine_type)
        VALUES (@process_id, @cutting_type, @machine_type);
    END
    ELSE IF @process_type = 'Paint'
    BEGIN
        INSERT INTO Paint (process_id, paint_type, painting_method)
        VALUES (@process_id, @paint_type, @painting_method);
    END
    ELSE IF @process_type = 'Fit'
    BEGIN
        INSERT INTO Fit (process_id, fit_type)
        VALUES (@process_id, @process_info);
    END
    ELSE
    BEGIN
        PRINT 'Invalid process type.';
        -- You can handle the case where an invalid type is provided.
    END
END;

---------------------4. Enter a new assembly with its customer-name, assembly-details, assembly-id, and date-ordered and associate it with one or more processes----------
GO
CREATE PROCEDURE NewAssembly
    @assembly_id INT,
    @date_ordered VARCHAR(255),
    @customer_name VARCHAR(255),
    @assembly_details VARCHAR(255),
    @process_id INT
AS
BEGIN
    -- Check if the assembly ID exists
    IF EXISTS (SELECT 1 FROM Assemblies WHERE assembly_id = @assembly_id)
    BEGIN
        PRINT 'Assembly ID exists.';
    END
    IF NOT EXISTS (SELECT 1 FROM Processes WHERE process_id = @process_id)
    BEGIN
        PRINT 'Process ID does not exist.';
        RETURN;
    END

    -- Insert data into the Assemblies table
    INSERT INTO Assemblies (assembly_id, date_ordered, assembly_details)
    VALUES (@assembly_id, @date_ordered, @assembly_details);

    -- Insert data into the Orders table
    INSERT INTO Orders (assembly_id, customer_name)
    VALUES (@assembly_id, @customer_name);

    -- Insert data into the Manufacture table
    INSERT INTO Manufacture (assembly_id, process_id)
    VALUES (@assembly_id, @process_id);
END;

-----------------------------5.Create a new account and associate it with the process, assembly, or department to which it is applied----------------

GO
CREATE PROCEDURE CreateAccount
    @account_num INT,
    @date_account_established VARCHAR(15),
    @process_id INT ,
    @cost_details_3 DECIMAL ,
    @cost_details_2 DECIMAL ,
    @cost_details_1 DECIMAL ,
    @department_data VARCHAR(255) ,
    @assembly_details VARCHAR(255),
    @account_type VARCHAR(50),
    @department_num INT,
    @assembly_id INT
AS
BEGIN
    -- Check if the account exists
    IF EXISTS (SELECT 1 FROM Account WHERE account_num = @account_num)
    BEGIN
        PRINT 'Account already exists.';
        RETURN;
    END

    -- Create a new account
    INSERT INTO Account (account_num, date_account_established)
    VALUES (@account_num, @date_account_established);

    -- Prompt the user for the type of account if not provided
    IF @account_type IS NULL
    BEGIN
        SET @account_type = (SELECT UPPER(
            CAST(
                (SELECT N'Enter account type (Process, Department, or Assembly): ') AS NVARCHAR(MAX))
            )
        );

        WHILE @account_type NOT IN ('PROCESS', 'DEPARTMENT', 'ASSEMBLY')
        BEGIN
            PRINT 'Invalid account type. Please enter Process, Department, or Assembly.';
            SET @account_type = (SELECT UPPER(
                CAST(
                    (SELECT N'Enter account type (Process, Department, or Assembly): ') AS NVARCHAR(MAX))
                )
            );
        END
    END
END

    -- Insert into the respective account type table
    IF @account_type = 'PROCESS'
    BEGIN
        -- Insert into Process_Account table
        INSERT INTO Process_Account (account_num, cost_details_3)
        VALUES (@account_num, @cost_details_3);

        -- Maintain the process through Maintain_Process
        IF @process_id IS NOT NULL
        BEGIN
            INSERT INTO Maintain_Process (process_id, account_num)
            VALUES (@process_id, @account_num);
        END
    END
    ELSE IF @account_type = 'DEPARTMENT'
    BEGIN
        -- Insert into Department_Account table
        INSERT INTO Department_Account (account_num, cost_details_2)
        VALUES (@account_num, @cost_details_2);

        IF @department_num IS NOT NULL
        BEGIN
            INSERT INTO Maintain_Department (department_num, account_num)
            VALUES (@department_num, @account_num);
        END

    END
    ELSE IF @account_type = 'ASSEMBLY'
    BEGIN
        -- Insert into Assembly_Account table
        INSERT INTO Assembly_Account (account_num, cost_details_1)
        VALUES (@account_num, @cost_details_1);

        IF @assembly_id IS NOT NULL
        BEGIN
            INSERT INTO Maintain_Assembly (assembly_id, account_num)
            VALUES (@assembly_id, @account_num);

        -- Connect to the Assembly table
        -- Add your logic here based on the requirements
    END
END;

-----------------------------6.Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced -----------------------------------------------------------------
GO
CREATE PROCEDURE EnterNewJob
    @job_no INT,
    @assembly_id INT,
    @process_id INT,
    @job_commenced_date VARCHAR(20),
    @job_type VARCHAR(15),
    @color VARCHAR(255),
    @volume VARCHAR(255),
    @machine_type_used VARCHAR(255),
    @material_used VARCHAR

AS
BEGIN
    INSERT INTO Job(job_no, job_commenced_date, job_completed_date) 
    VALUES (@job_no, @job_commenced_date, NULL)
    INSERT INTO Assigns (assembly_id, process_id, job_no) 
    VALUES (@assembly_id, @process_id, @job_no);
IF @job_type = 'paint'
        BEGIN
            INSERT INTO Paint_Job(job_no, color, volume, labour_time) 
            VALUES (@job_no, @color, @volume, NULL)
        END
        ELSE IF @job_type = 'fit'
        BEGIN
            INSERT INTO Fit_Job(job_no, labour_time) 
            VALUES (@job_no, NULL)
        END
        ELSE IF @job_type = 'cut'
        BEGIN
            INSERT INTO Cut_Job(job_no, machine_type_used, time_machine_used, material_used, labour_time) 
            VALUES (@job_no, @machine_type_used, NULL, @material_used, NULL)
        END
    
END;

----------------------------7.  At the completion of a job, enter the date it completed and the information relevant to the type of job---
GO
CREATE PROCEDURE InsertJobData
    @job_no INT,
    @completion_date VARCHAR(15),
    @process_type VARCHAR(225), 
    @labour_time DECIMAL(10,2),
    @time_machine_used DECIMAL(10,2)
    
AS
BEGIN
    UPDATE Job
    SET job_completed_date = @completion_date
    WHERE job_no = @job_no;

    SELECT @process_type = 
        CASE
            WHEN EXISTS (SELECT 1 FROM Cut_Job WHERE job_no = @job_no) THEN 'Cut'
            WHEN EXISTS (SELECT 1 FROM Fit_Job WHERE job_no = @job_no) THEN 'Fit'
            WHEN EXISTS (SELECT 1 FROM Paint_Job WHERE job_no = @job_no) THEN 'Paint'
            ELSE NULL
        END;

   IF @process_type = 'Cut'
    BEGIN

        Update Cut_Job SET 
        time_machine_used = @time_machine_used,
        labour_time = @labour_time
        WHERE job_no = @job_no;
        
    END

    ELSE IF @process_type = 'Fit'
    BEGIN
        Update Fit_Job SET 
        labour_time = @labour_time
        WHERE job_no = @job_no;
    
    END
    ELSE IF @process_type = 'Paint'
    BEGIN
        Update Paint_Job SET 
        labour_time = @labour_time
        WHERE job_no = @job_no;
    END


END;

-------------------------------------8. Enter a transaction-no and its sup-cost and update all the costs (details) of the affected accounts by adding sup-cost to their current values of details-------

GO
CREATE PROCEDURE enterTransactionNum
    @transaction_num INT,
    @sup_cost DECIMAL,
    @account_num INT
AS
BEGIN
    -- Check if the transaction number already exists
    IF EXISTS (SELECT 1 FROM Transactions WHERE transaction_num = @transaction_num)
    BEGIN
        PRINT 'Transaction number already exists.';
        RETURN;
    END
    
    INSERT INTO Transactions(transaction_num,sup_cost, account_num) VALUES
    (@transaction_num, @sup_cost, @account_num)

    IF EXISTS (SELECT 1 FROM Process_Account WHERE account_num = @account_num)
    BEGIN
        UPDATE Process_Account
        SET cost_details_3 = cost_details_3 + @sup_cost
        WHERE account_num = @account_num;
    END

    -- Update assembly account details
    IF EXISTS (SELECT 1 FROM Assembly_Account WHERE account_num = @account_num)
    BEGIN
        UPDATE Assembly_Account
        SET cost_details_1 = cost_details_1 + @sup_cost
        WHERE account_num = @account_num;
    END

    -- Update department account details
    IF EXISTS (SELECT 1 FROM Department_Account WHERE account_num = @account_num)
    BEGIN
        UPDATE Department_Account
        SET cost_details_2 = cost_details_2 + @sup_cost
        WHERE account_num = @account_num;
    END
END;

---------------------------9.  Retrieve the total cost incurred on an assembly-id ----------------------------------
GO
CREATE PROCEDURE GetTotalCostForAssembly
    @assembly_id INT,
    @total_cost DECIMAL(10, 2) OUTPUT
AS
BEGIN

    -- Calculate total cost
    SELECT @total_cost = COALESCE(SUM(t.sup_cost), 0)
    FROM Assemblies AS a
    LEFT JOIN Maintain_Assembly AS ma ON a.assembly_id = ma.assembly_id
    LEFT JOIN Transactions AS t ON ma.account_num = t.account_num
    WHERE a.assembly_id = @assembly_id;

    -- Print the result
    -- PRINT 'Total Cost for Assembly ID ' + CAST(@assembly_id AS VARCHAR) + ': ' + CAST(@total_cost AS VARCHAR);
END;

---------------------------------10. Retrieve the total labor time within a department for jobs completed in the department during a given date-------------------------
GO
CREATE PROCEDURE GetTotalLaborTime
    @department_num INT,
    @completion_date VARCHAR(15),
    @total_labor_time DECIMAL(10, 2) OUTPUT
AS
BEGIN
    -- Declare a variable to store the total labor time

    -- Calculate the total labor time
    SELECT @total_labor_time = ISNULL(SUM(labour_time), 0)
    FROM (
        SELECT labour_time
        FROM Fit_Job AS fj
        WHERE fj.job_no IN (
            SELECT job_no
            FROM Job
            WHERE job_completed_date = @completion_date
                AND job_no IN (
                    SELECT job_no
                    FROM Assigns
                    WHERE process_id IN (
                        SELECT process_id
                        FROM Supervised
                        WHERE department_num = @department_num
                    )
                )
        )

        UNION ALL

        SELECT labour_time
        FROM Paint_Job AS pj
        WHERE pj.job_no IN (
            SELECT job_no
            FROM Job
            WHERE job_completed_date = @completion_date
                AND job_no IN (
                    SELECT job_no
                    FROM Assigns
                    WHERE process_id IN (
                        SELECT process_id
                        FROM Supervised
                        WHERE department_num = @department_num
                    )
                )
        )

        UNION ALL

        SELECT labour_time
        FROM Cut_Job AS cj
        WHERE cj.job_no IN (
            SELECT job_no
            FROM Job
            WHERE job_completed_date = @completion_date
                AND job_no IN (
                    SELECT job_no
                    FROM Assigns
                    WHERE process_id IN (
                        SELECT process_id
                        FROM Supervised
                        WHERE department_num = @department_num
                    )
                )
        )
    ) AS LaborTimes;

    -- Print the total labor time
    PRINT 'Total Labor Time in Department ' + CAST(@department_num AS VARCHAR) + ' for Jobs Completed on ' + CAST(@completion_date AS VARCHAR) + ': ' + CAST(@total_labor_time AS VARCHAR);
END;

------------------------------------------------11. Retrieve the processes through which a given assembly-id has passed so far (in date-commenced order) and the department responsible for each process-----------------------
GO
CREATE PROCEDURE GetProcessDepartmentDetails
    @assembly_id INT 
AS
BEGIN
    SELECT 
        S.process_id, 
        S.department_num
    FROM 
        Supervised AS S
    INNER JOIN 
        Assigns AS A ON S.process_id = A.process_id
    INNER JOIN 
        Job AS J ON J.job_no = A.job_no
    WHERE 
        A.assembly_id = @assembly_id
    ORDER BY 
        J.job_commenced_date;
END;


---------------------------------12. Retrieve the customers (in name order) whose category is in a given range------------
GO
CREATE PROCEDURE GetCustomersByCategoryRange
    @start_category INT,
    @end_category INT
AS
BEGIN
    -- Print the header
    PRINT 'Customer Names in Category Range ' + CAST(@start_category AS VARCHAR) + ' to ' + CAST(@end_category AS VARCHAR) + ':';
    PRINT '-----------------------------------';

    -- Select and print customer names
    SELECT
        customer_name
    FROM
        Customer
    WHERE
        category BETWEEN @start_category AND @end_category
    ORDER BY
        customer_name;
END;

-------------------------------------------------13. Delete all cut-jobs whose job-no is in a given range----------------------------------------

GO
CREATE PROCEDURE DeleteCutJobsByJobNoRange
    @start_job_no INT,
    @end_job_no INT
AS
BEGIN
    -- Delete cut-jobs
    DELETE FROM Cut_Job
    WHERE
        job_no BETWEEN @start_job_no AND @end_job_no;

    -- Print a message indicating the deletion
    PRINT 'Cut-Jobs with Job No in the range ' + CAST(@start_job_no AS VARCHAR) + ' to ' + CAST(@end_job_no AS VARCHAR) + ' deleted.';
END;

-----------------------------------------14. Change the color of a given paint job ------------------------------------------
GO
CREATE PROCEDURE ChangePaintJobColor
    @job_no INT,
    @new_color VARCHAR(255)
AS
BEGIN
    -- Update the color of the paint job
    UPDATE Paint_Job
    SET color = @new_color
    WHERE job_no = @job_no;

    -- Print a message indicating the update
    PRINT 'Color of Paint Job with Job No ' + CAST(@job_no AS VARCHAR) + ' changed to ' + @new_color + '.';
END;
-------------------------------------------------16. Export Customers----------------------------------------------------------------------------

GO
CREATE PROCEDURE ExportCustomer
    @min INT,
    @max INT
AS
BEGIN
    SELECT * FROM  Customer
    WHERE category BETWEEN @min and @max

END;