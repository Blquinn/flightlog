module dateutil;

import std.datetime;
import std.datetime.date;
import std.typecons;

Date sysTimeToDate(SysTime time) {
    DateTime dt = cast(DateTime) time.toLocalTime();
    return dt.date();
}

Date unixToDate(int unix) {
    return sysTimeToDate(SysTime.fromUnixTime(unix));
}

// Returns unix timestamps for the beggining of d and the beginning of the following day.
Tuple!(long, long) boundsForDate(Date d) {
    return tuple(
        SysTime(d).toUnixTime,
        SysTime(d.roll!"days"(1)).toUnixTime
    );
}
