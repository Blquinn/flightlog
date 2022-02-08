module commands.list;

import core.stdc.stdlib;
import std.conv;
import std.stdio;
import std.range;
import std.datetime.date;
import std.datetime;
import std.algorithm.searching;

import d2sqlite3;

import dateutil;
import db;

Date parseDate(Database* db, string arg) {
	try {
		return Date.fromISOExtString(arg);
	} catch (Exception e) {
	}

	int dayId;
	try {
		dayId = arg.to!int;
	} catch (ConvException e) {
		writeln("Argument <day_id> must be a valid integer, or iso date.");
		exit(4);
	}

	if (dayId == 1)
		return sysTimeToDate(Clock.currTime());

	return dateFromDayId(db, dayId);
}

void listLogs(Database* db, string[] args) {
	Date date;
	if (args.empty)
		date = sysTimeToDate(Clock.currTime());
	else
		date = parseDate(db, args[0]);

	writeln("Logs for ", date.toISOExtString());
	writeln();

	auto stmt = db.prepare("select msg from log where date like ? || '%'");
	stmt.bindAll(date.toISOExtString());
	auto results = stmt.execute();

	bool hasResults = false;
	int i = 1;
	foreach (row; results) {
		hasResults = true;
		writefln("%d - %s", i, row["msg"].as!string);
		i++;
	}

	if (!hasResults)
		writeln("No logs for date ", date.toISOExtString());
}
