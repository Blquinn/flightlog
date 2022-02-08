module db;


import std.range;
import std.algorithm.iteration;
import std.algorithm.searching;
import std.datetime;
import std.datetime.date;
import std.conv;
import std.stdio;
import core.stdc.stdlib;

import d2sqlite3;

struct DayCount {
    Date date;
    int count;
    int dayId;
}

DayCount[] getCountsByDate(Database* db) {
    auto results = db.execute(" select date from log order by timestamp; ");

    auto arr = results.map!(row => (cast(DateTime) SysTime.fromISOExtString(row[0].as!string)
            .toLocalTime()).date())
        .group
        .map!(rec => DayCount(rec[0], rec[1]))
        .array;

    auto dayId = arr.length.to!int;
    for (int i = 0; i < arr.length; i++) {
        arr[i].dayId = dayId;
        dayId--;
    }

    return arr;
}

Date dateFromDayId(Database* db, int dayId) {
	auto counts = getCountsByDate(db);
	auto dayCounts = counts.find!(c => c.dayId == dayId);
	if (dayCounts.empty) {
		writefln("Day id %d does not exist. (You can use <hist> to find valid day ids.)", dayId);
		exit(5);
	}

	return dayCounts[0].date;
}
