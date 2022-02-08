module commands.log;

import std.stdio;
import std.datetime;
import std.range;
import std.string;

import d2sqlite3;

void addLog(Database* db, string[] args) {
	string msg;
	if (args.empty) {
		write("> ");
		msg = readln().stripRight();
	} else {
		msg = args.join(' ');
	}

	auto now = Clock.currTime();
	auto stmt = db.prepare("insert into log (msg, timestamp, date) values (?, ?, ?);");
	stmt.bindAll(msg, now.toUnixTime(), now.toUTC().toISOExtString());
	stmt.execute();
	// db.execute("SELECT last_insert_rowid()");
	// foreach (row; results)
	// {
	// 	auto id = row[0].as!int;
	// 	writeln("Inserted new row ", id);
	// }
}
