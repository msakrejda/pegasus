-- Some basic bootstrap SQL for the pegasus functional tests
\set ON_ERROR_STOP

drop database if exists pegasus;
drop user if exists pegasus;

create user pegasus with password 'pegasus';
create database pegasus with owner pegasus;