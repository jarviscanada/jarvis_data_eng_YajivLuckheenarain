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
    #Press "esc" to enter normal mode then ":wq" + "Enter" to save and exit the cronjob editor
    ```

With these commands, you can quickly set up the project and begin monitoring your system.



# Implemenation
Discuss how you implement the project.
## Architecture
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to the `assets` directory.

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
