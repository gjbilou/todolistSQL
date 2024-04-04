
# TodoList Project

## Project Overview

The TodoList Project is a SQL-based application aimed at managing and organizing tasks using an Oracle Database. It is designed to demonstrate a comprehensive understanding of relational database management systems (RDBMS) through the implementation of table creation, data manipulation, integrity constraints, triggers, and stored procedures. This project provides a practical example of database design and functionality.

## Purpose of the Project

The primary goal of this project is to create a functional todo list application that utilizes various SQL scripts and PL/SQL procedures to manage tasks efficiently. It serves as an example of how to structure a database, insert and manipulate data, and use advanced database features like triggers and stored procedures to automate tasks within the database.

## Prerequisites

Before setting up the TodoList Project, you need to have Oracle Database installed and configured on your system. This project is developed specifically for Oracle Database environments, requiring familiarity with Oracle SQL syntax and features, allowing us to use PL/SQL.

## Setup Instructions

### Compiling the Database

After ensuring that Oracle Database is installed on your system, follow these steps to set up the TodoList Project:

#### 1. Database Creation

Start by running the `MasterTodoList.sql` script to create the main database structure. This script initializes the necessary tables and relationships for the todo list application.

#### 2. Table Setup

Execute the `TodoListCreationTable.sql` script to create all required tables according to the project schema.

#### 3. Sample Data Insertion

Use the `TodoListInsertion.sql` script to populate the tables with sample data, which is essential for demonstration and testing purposes.

#### 4. Implementing Triggers and Procedures

Apply the scripts `TodoListTriggers.sql` and `TodoListProcedures.sql` to incorporate automated behaviors and stored procedures into your database.

#### 5. Testing

Run the `scriptTest.sql` for testing the database functionality and ensuring that everything is set up correctly.

### Running the Project

With the Oracle Database setup and the initial scripts executed, you can begin exploring the todo list application. Use `TodoListRequest.sql` for common database operations such as querying for specific tasks.

## Additional Resources

- For a detailed explanation of the project's design and functionality, refer to the `RapportPrt2.pdf`.
- The `Modèle logique relationnel` and `contrainteIntergrite` folders contain valuable documentation on the database's logical model and integrity constraints, respectively.
