# salon-scheduler
 
 ## Description
 
 A Bash script that allows users to create appointments at a salon. The script uses SQL to store the appointments and users in a Postgres database.
 
 Created for freeCodeCamp's Relational Databases course.
 
 ## Database
 
Appointments - Stores appointments, which each contain a foreign key for a service, a foreign key for a customer, a time, and their own serial ID.
Customers - Stores customers, which have a name, unique phone number (used to identify them in the script), and a serial ID.
Services - Stores services, which each have a name and serial ID.

To create database, run 'psql -U postgres < salon.sql'

## Salon Script

Bash script to allow users to create appointments

Displays services, asks user to select a service, and then asks user for phone number
If no existing customer has that phone number, it asks for the name and adds the customer to the customers table
Then asks for the appointment time, and adds the appointment to the appointments table

To execute script, run './salon.sh'
