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
	if (args.empty) {
		auto results = db.execute("select timestamp from log order by timestamp desc limit 1;");
		date = results.empty ?
			sysTimeToDate(Clock.currTime())
			: unixToDate(results.front()[0].as!int);
	} else {
		date = parseDate(db, args[0]);
	}

	auto stmt = db.prepare("select msg from log where timestamp >= ? and timestamp < ?");
	auto bounds = boundsForDate(date);
	stmt.bindAll(bounds[0], bounds[1]);
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
