module commands.log;

import std.stdio;
import std.datetime;
import std.range;
import std.string;

import d2sqlite3;

void addLog(Database* db, string[] args) {
	string msg;
	if (args.empty) {
		writeln("Enter a message");
		write("> ");
		msg = readln().stripRight();
	} else {
		msg = args.join(' ');
	}

	auto now = Clock.currTime();
	auto stmt = db.prepare("insert into log (msg, timestamp) values (?, ?);");
	stmt.bindAll(msg, now.toUnixTime());
	stmt.execute();
}
