module dateutil;

import std.datetime;
import std.datetime.date;

Date sysTimeToDate(SysTime time) {
    DateTime dt = cast(DateTime) time.toLocalTime();
    return dt.date();
}

Date unixToDate(int unix) {
    return sysTimeToDate(SysTime.fromUnixTime(unix));
}
