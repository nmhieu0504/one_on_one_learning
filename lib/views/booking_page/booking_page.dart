// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final now = DateTime.now();
  late BookingService mockBookingService;
  List<DateTimeRange> converted = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    mockBookingService = BookingService(
        serviceName: 'Booking Service',
        serviceDuration: 60,
        bookingStart: DateTime(now.year, now.month, now.day, 0, 0, 0),
        bookingEnd: DateTime(now.year, now.month, now.day, 23, 59, 59));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    print("DATE CHANGED");
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    // await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data

    DateTime tomorrow = now.add(const Duration(days: 1));
    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));

    // converted.add(
    //     DateTimeRange(start: now, end: now.add(const Duration(minutes: 30))));
    // converted.add(DateTimeRange(
    //     start: second, end: second.add(const Duration(minutes: 23))));
    // converted.add(DateTimeRange(
    //     start: third, end: third.add(const Duration(minutes: 15))));
    // converted.add(DateTimeRange(
    //     start: fourth, end: fourth.add(const Duration(minutes: 50))));

    converted.add(DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 0, 0, 0),
        end: DateTime(now.year, now.month, now.day, 5, 0, 0)));

    //book whole day example
    converted.add(DateTimeRange(
        start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
        end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)));
    return converted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Schedule'),
      ),
      body: Center(
        child: BookingCalendar(
          bookingService: mockBookingService,
          convertStreamResultToDateTimeRanges: convertStreamResultMock,
          getBookingStream: getBookingStreamMock,
          uploadBooking: uploadBookingMock,
          loadingWidget: const Text('Fetching data...'),
          uploadingWidget: const CircularProgressIndicator(),
          locale: 'en_EN',
          wholeDayIsBookedWidget: const Center(
              child: Text('Sorry, for this day everything is booked')),
        ),
      ),
    );
  }
}
