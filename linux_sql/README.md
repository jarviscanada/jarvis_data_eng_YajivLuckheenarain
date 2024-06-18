Note: You are NOT allowed to copy any content from the scrum board, including text, diagrams, code, etc. Your Github will be visible and shared with Jarvis clients, so you have to create unique content that impresses your future boss😎.

# Introduction
(about 100-150 words)
Discuss the design of the project. What does this project/product do? Who are the users? What are the technologies you have used? (e.g. bash, docker, git, etc..)

This project is designed to monitor and log hardware specifications and dynamic resource usage of a computer system. It targets system administrators and developers who need to track and analyze system performance. The core functionality is implemented using several technologies including Bash, Docker, Git, and PostgreSQL.

The project employs a psql_docker.sh shell script to create a PostgreSQL Docker instance and a Docker volume. A ddl.sql file initializes two PostgreSQL tables: host_info and host_usage, if they do not already exist. The host_info.sh script, executed once, gathers hardware specifications of the host computer and stores this data in the host_info table, which uniquely identifies the computer. The host_usage.sh script runs periodically via a cron job every minute. It retrieves the host identifier and logs the current resource usage into the host_usage table. The project is developed and operated in a Linux environment.

# Quick Start
Use markdown code block for your quick-start commands
- Start a psql instance using psql_docker.sh
- Create tables using ddl.sql
- Insert hardware specs data into the DB using host_info.sh
- Insert hardware usage data into the DB using host_usage.sh
- Crontab setup

# Quick Start

To quickly set up and run the project, follow these commands:

1. Clone the repository and change into the linux_sql directory:
    ```sh
    git clone https://github.com/jarviscanada/jarvis_data_eng_YajivLuckheenarain.git
    cd jarvis_data_eng_YajivLuckheenarain/linux_sql
    ```

2. Create and Start the PostgreSQL Docker instance:
    ```sh
    ./scripts/psql_docker.sh create [username] [password]
    ./scripts/psql_docker.sh start
    ```
    
3. Run the DDL script to create tables:

   1. **Optional**: Create the `host_agent` database if it doesn't exist:

      ```sh
      psql -h localhost -U [username] -W
      ```

      ```sql
      -- Enter your password when prompted
      CREATE DATABASE host_agent;
      \q
      ```

   2. Run the DDL script to create tables:

      ```sh
      psql -h localhost -U [username] -d host_agent -f sql/ddl.sql
      ```


4. Collect hardware info and store it in the database:
    ```sh
    ./scripts/host_info.sh localhost 5432 host_agent [username] [password]
    ```

5. Set up the cron job to log usage data every minute:
    ```sh
    crontab -e
    #Press "i" to enter insert mode and write the following line with the previously defined username/password to the crontab file:
    * * * * * /path/to/project/host_usage.sh localhost 5432 host_agent [username] [password] > /tmp/host_usage.log
    #Press "esc" to enter normal mode then ":wq" then "Enter" to save and exit the cronjob editor
    ```

With these commands, you can quickly set up the project and begin monitoring your system.



# Implemenation
Discuss how you implement the project.
## Architecture
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to the `assets` directory.

![Cluster Diagram](assets/Clustering%20Diagram.png)



## Scripts
Shell script description and usage (use markdown code block for script usage)
- psql_docker.sh
- host_info.sh
- host_usage.sh
- crontab
- queries.sql (describe what business problem you are trying to resolve)

## Database Modeling
Describe the schema of each table using markdown table syntax (do not put any sql code)
- `host_info`
- `host_usage`

### host_info Table Schema

| Column Name       | Data Type | Constraints        | Description                  |
|-------------------|-----------|--------------------|------------------------------|
| id                | SERIAL    | PRIMARY KEY        | Unique identifier            |
| hostname          | VARCHAR   | NOT NULL, UNIQUE   | Hostname                     |
| cpu_number        | INT2      | NOT NULL           | Number of CPUs               |
| cpu_architecture  | VARCHAR   | NOT NULL           | CPU architecture             |
| cpu_model         | VARCHAR   | NOT NULL           | CPU model                    |
| cpu_mhz           | FLOAT8    | NOT NULL           | CPU clock speed (MHz)        |
| l2_cache          | INT4      | NOT NULL           | L2 cache size (bytes)        |
| timestamp         | TIMESTAMP |                    | Timestamp of data insertion  |
| total_mem         | INT4      |                    | Total memory (optional)      |

### host_usage Table Schema

| Column Name       | Data Type | Constraints        | Description                    |
|-------------------|-----------|--------------------|--------------------------------|
| timestamp         | TIMESTAMP | NOT NULL           | Timestamp of data recording    |
| host_id           | SERIAL    | NOT NULL           | Host identifier (foreign key)  |
| memory_free       | INT4      | NOT NULL           | Free memory in bytes           |
| cpu_idle          | INT2      | NOT NULL           | Idle CPU percentage            |
| cpu_kernel        | INT2      | NOT NULL           | Kernel CPU percentage          |
| disk_io           | INT4      | NOT NULL           | Disk I/O operations           |
| disk_available    | INT4      | NOT NULL           | Available disk space (bytes)   |


# Test
How did you test your bash scripts DDL? What was the result?

# Deployment
How did you deploy your app? (e.g. Github, crontab, docker)

# Improvements
Write at least three things you want to improve 
e.g. 
- handle hardware updates 
- blah
- blah

# Improvements

1. **Unified Script Execution**:
   - **Goal**: Abstract all individual scripts into one executable for easier quick start.
   - **Description**: Combine scripts or create a master script that automates the setup process, reducing the complexity of running multiple commands manually.
   - **Benefits**: Simplifies onboarding for new users, reduces potential for errors, and ensures consistency in deployment steps.

2. **Controlled Output Visibility**:
   - **Goal**: Provide options to control visibility of intermediate outputs, especially for commands like Docker container creation.
   - **Description**: Implement flags or options in scripts to toggle verbose or silent modes, allowing users to decide whether they want to see detailed outputs or suppress them (e.g., redirecting stdout to `/dev/null`).
   - **Benefits**: Enhances user experience by reducing clutter in terminal outputs, while still allowing users to debug or monitor processes when needed.

3. **Improved Database Interaction Interface**:
   - **Goal**: Develop a cleaner interface for interacting with databases, particularly when reading data through the terminal.
   - **Description**: Enhance scripts or create utilities that improve readability and usability when querying or viewing database contents, possibly incorporating formatted outputs or interactive prompts.
   - **Benefits**: Facilitates easier data inspection and understanding, especially in complex or large datasets, enhancing productivity and troubleshooting capabilities.

