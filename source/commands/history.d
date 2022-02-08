module commands.history;

import std.stdio;

import d2sqlite3;

import db;

void listHistory(Database* db) {
	auto results = getCountsByDate(db);

	foreach (res; results) {
		writefln("%d - %s (%d entries)", res.dayId, res.date.toISOExtString(), res.count);
	}
}
