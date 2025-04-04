echo "Hello"

psql -U postgres -c "CREATE USER admin_cee WITH PASSWORD 'password';"
psql -U postgres -c "ALTER USER admin_cee WITH SUPERUSER;"

psql -U ituser -d postgres -c "DROP DATABASE IF EXISTS company_db;"
psql -U ituser -d postgres -c "CREATE DATABASE company_db;"
psql -U ituser -d company_db -c "\i data.sql"

# restoring the data seems to change the search path of the user and accessing the tables was no longer possible
psql -U ituser -d company_db -c "SET search_path TO public;" 

# Clear logs.txt
> /logs.txt

psql -U ituser -d company_db -c "SELECT COUNT(*) FROM employees;" >> logs.txt

psql -U ituser -d company_db -c "SELECT department_id, department_name FROM departments;"
echo "Please enter the department_id:"
read department_id
psql -U ituser -d company_db -c "SELECT first_name || ' ' || last_name AS name
                                 FROM employees
                                 WHERE department_id = $department_id;" >> logs.txt
psql -U ituser -d company_db -c "SELECT department_name, MAX(salary) AS highest_salary, MIN(salary) AS lowest_salary
                                 FROM employees
                                 JOIN departments ON employees.department_id = departments.department_id
                                 JOIN salaries ON employees.employee_id = salaries.employee_id
                                 GROUP BY department_name;" >> logs.txt

echo "Check /logs.txt for results";