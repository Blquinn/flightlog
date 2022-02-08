import std.stdio;
import d2sqlite3;
import std.datetime;
import std.datetime.date;
import std.format;
import std.conv;
import std.container.array;
import std.algorithm.iteration;
import std.algorithm.searching;
import core.stdc.stdlib;
import std.range;
import std.typecons;

import db;
import dateutil;
import commands.log;
import commands.list;
import commands.history;
import commands.edit;

void printHelp() {
	const help = "Flightlog is a utility to log your day's activities.

Usage: flt [--version] [<command>] [<options...>]

Available commands
==================

  log [<message>]
    Logs a message. Prompts to read from stdin if no message is supplied.

  list [<day_id>]
    Lists todays logs.

  hist
    Lists historical log info.

    Format - <day_id> - <date> (<num_entries> entries)

  edit [<day_id>] [<entry_id>]
    Edits existing entry.
";
	writeln(help);
	exit(0);
}

void main(string[] args) {
	args = args[1 .. $];

	if (args.empty)
		printHelp();

	if (args[0] == "--help" || args[0] == "-h")
		printHelp();

	string cmd = args[0];
	args = args[1 .. $];
	// TODO: Move this to user dir.
	auto db = Database("fltlog.db");

	switch (cmd) {
	case "log":
		addLog(&db, args);
		break;
	case "list":
		listLogs(&db, args);
		break;
	case "hist":
		listHistory(&db);
		break;
	case "edit":
		editLog(&db, args);
		break;
	default:
		writeln("Unexpected command", cmd);
		exit(99);
	}
}
