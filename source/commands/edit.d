module commands.edit;

import std.stdio;
import std.range;
import std.datetime;
import std.conv;
import core.stdc.stdlib;
import std.string;

import d2sqlite3;

import db;
import dateutil;

// variants are <day_id> <log_id> | <log_id>
void editLog(Database* db, string[] args) {
    Date date;
    int logId;

    // TODO: Handle conversion errors.
    if (args.length == 1) {
        date = sysTimeToDate(Clock.currTime());
        logId = args[0].to!int;
    } else if (args.length == 2) {
        date = dateFromDayId(db, args[0].to!int);
        logId = args[1].to!int;
    } else {
        writeln("Argument <log_id> is required.");
        exit(1);
    }

    auto bounds = boundsForDate(date);

    auto stmt = db.prepare(
        "select id, timestamp, msg 
from log 
where timestamp >= ? and timestamp < ?
order by timestamp;");

    stmt.bindAll(bounds[0], bounds[1]);
    auto results = stmt.execute();

    int logPk;
    string msg;
    SysTime timestamp;
    int i = 1;
    foreach (row; results) {
        if (i == logId) {
            logPk = row["id"].as!int;
            msg = row["msg"].as!string;
            timestamp = SysTime.fromUnixTime(row["timestamp"].as!int);
            break;
        }

        i++;
    }

    if (logPk < 1) {
        writefln("Log with id %d not found for day %s.", logId, date.toISOExtString());
        exit(1);
    }

    writefln("Editing message %s - %d - \"%s\"", sysTimeToDate(timestamp)
            .toISOExtString(), logId, msg);
    write("> ");
    auto newMsg = readln().stripRight();

    stmt = db.prepare("update log set msg = ? where id = ?;");
    stmt.bindAll(newMsg, logPk);
    stmt.execute();
}
