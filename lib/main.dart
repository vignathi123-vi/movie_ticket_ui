import 'package:flutter/material.dart';

// ---------------------------------------------------------------
// MOVIE TICKET UI  -  simple Flutter web app
// Screens: Home -> Details -> Seats -> Ticket
// ---------------------------------------------------------------

void main() {
  runApp(const MovieApp());
}

// ---------- DATA: one Movie class + a list of movies ----------
class Movie {
  final String name;
  final String genre;
  final String duration;
  final String cast;
  final String description;
  final double rating;
  final int price; // price of ONE ticket in rupees
  final Color color1;
  final Color color2;
  final IconData icon;

  const Movie({
    required this.name,
    required this.genre,
    required this.duration,
    required this.cast,
    required this.description,
    required this.rating,
    required this.price,
    required this.color1,
    required this.color2,
    required this.icon,
  });
}

const List<Movie> movies = [
  Movie(
    name: 'Disclosure Day',
    genre: 'Sci-Fi',
    duration: '2h 30m',
    cast: 'A. Kumar, R. Sharma, S. Rao',
    description:
        'A crew of astronauts travels beyond the solar system to find a new home for humanity.',
    rating: 8.7,
    price: 250,
    color1: Color(0xFF1A237E),
    color2: Color(0xFF7B1FA2),
    icon: Icons.rocket_launch,
  ),
  Movie(
    name: 'Little Hearts',
    genre: 'Comedy',
    duration: '2h 05m',
    cast: 'P. Reddy, M. Iyer, T. Naidu',
    description:
        'Four friends plan a simple wedding, but everything that can go wrong goes wrong.',
    rating: 7.9,
    price: 200,
    color1: Color(0xFFF57F17),
    color2: Color(0xFFE65100),
    icon: Icons.theater_comedy,
  ),
  Movie(
    name: 'Priyuralu Pilichindhi',
    genre: 'Action',
    duration: '2h 20m',
    cast: 'V. Singh, N. Das, K. Menon',
    description:
        'A retired police officer has one night to stop a gang before they escape the city.',
    rating: 8.2,
    price: 280,
    color1: Color(0xFFB71C1C),
    color2: Color(0xFF212121),
    icon: Icons.local_fire_department,
  ),
  Movie(
    name: 'Fida',
    genre: 'Romance',
    duration: '2h 10m',
    cast: 'S. Devi, A. Khan, L. Joseph',
    description:
        'Two strangers meet on a seaside trip and a short holiday changes their lives forever.',
    rating: 8.0,
    price: 220,
    color1: Color(0xFF006064),
    color2: Color(0xFFAD1457),
    icon: Icons.favorite,
  ),
  Movie(
    name: 'Stree',
    genre: 'Horror',
    duration: '1h 55m',
    cast: 'R. Pillai, D. Roy, B. Nair',
    description:
        'A group of students spends one night in an old hall, and they are not alone.',
    rating: 7.4,
    price: 230,
    color1: Color(0xFF263238),
    color2: Color(0xFF4A148C),
    icon: Icons.nightlight_round,
  ),
  Movie(
    name: 'Tangled',
    genre: 'Animation',
    duration: '1h 40m',
    cast: 'Voices: J. Paul, C. Bose',
    description:
        'A small group of toy animals goes on a big adventure to save their toy shop.',
    rating: 8.5,
    price: 180,
    color1: Color(0xFF2E7D32),
    color2: Color(0xFF00ACC1),
    icon: Icons.pets,
  ),
];

// ---------- APP ROOT ----------
class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChitraVahini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ---------- SMALL REUSABLE WIDGET: the "poster" box ----------
class PosterBox extends StatelessWidget {
  final Movie movie;
  final double height;
  const PosterBox({super.key, required this.movie, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [movie.color1, movie.color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(movie.icon, size: height * 0.4, color: Colors.white70),
    );
  }
}

// ===============================================================
// SCREEN 1: HOME  (list of movies)
// ===============================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('"ChitraVahini" Now Showing'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 260,
          childAspectRatio: 0.68,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(movie: movie),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: PosterBox(movie: movie, height: 500)),
                    const SizedBox(height: 8),
                    Text(
                      movie.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${movie.rating}'),
                        const Spacer(),
                        Text(movie.genre,
                            style: const TextStyle(color: Colors.white60)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===============================================================
// SCREEN 2: DETAILS  (movie info + choose date and time)
// StatefulWidget because the chosen date/time changes on tap
// ===============================================================
class DetailsScreen extends StatefulWidget {
  final Movie movie;
  const DetailsScreen({super.key, required this.movie});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final List<String> dates = ['10 Nov', '11 Nov', '12 Nov', '13 Nov'];
  final List<String> times = ['10:00 AM', '01:30 PM', '06:45 PM', '09:30 PM'];
  int selectedDate = 0;
  int selectedTime = 0;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    return Scaffold(
      appBar: AppBar(title: Text(movie.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PosterBox(movie: movie, height: 220),
                const SizedBox(height: 16),
                Text(movie.name,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(' ${movie.rating}   |   ${movie.genre}   |   ${movie.duration}'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Story',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(movie.description),
                const SizedBox(height: 16),
                const Text('Cast',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(movie.cast),
                const SizedBox(height: 20),
                const Text('Select Date',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(dates.length, (i) {
                    return ChoiceChip(
                      label: Text(dates[i]),
                      selected: selectedDate == i,
                      onSelected: (value) {
                        setState(() {
                          selectedDate = i;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                const Text('Select Time',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(times.length, (i) {
                    return ChoiceChip(
                      label: Text(times[i]),
                      selected: selectedTime == i,
                      onSelected: (value) {
                        setState(() {
                          selectedTime = i;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeatScreen(
                            movie: movie,
                            date: dates[selectedDate],
                            time: times[selectedTime],
                          ),
                        ),
                      );
                    },
                    child: const Text('Book Ticket',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// SCREEN 3: SEATS  (tap a seat to select / unselect)
// ===============================================================
class SeatScreen extends StatefulWidget {
  final Movie movie;
  final String date;
  final String time;
  const SeatScreen({
    super.key,
    required this.movie,
    required this.date,
    required this.time,
  });

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  final List<String> rowNames = ['A', 'B', 'C', 'D', 'E', 'F'];
  final int seatsPerRow = 8;

  // seats that are already booked (cannot be selected)
  final Set<String> bookedSeats = {'A3', 'A4', 'C5', 'D2', 'D6', 'E7', 'F1'};

  // seats the user has selected
  final Set<String> selectedSeats = {};

  void toggleSeat(String seat) {
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  Widget legend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int total = selectedSeats.length * widget.movie.price;
    final int totalSeats = rowNames.length * seatsPerRow;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Seats')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${widget.movie.name}  |  ${widget.date}  |  ${widget.time}',
              style: const TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),
          // screen shape
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          const Text('SCREEN THIS SIDE',
              style: TextStyle(fontSize: 11, color: Colors.white54)),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: totalSeats,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: seatsPerRow,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final String row = rowNames[index ~/ seatsPerRow];
                    final int number = (index % seatsPerRow) + 1;
                    final String seat = '$row$number';

                    final bool isBooked = bookedSeats.contains(seat);
                    final bool isSelected = selectedSeats.contains(seat);

                    Color color = Colors.grey.shade800; // available
                    if (isBooked) color = Colors.red.shade900;
                    if (isSelected) color = Colors.green;

                    return GestureDetector(
                      onTap: isBooked ? null : () => toggleSeat(seat),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(seat,
                            style: const TextStyle(fontSize: 11)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                legend(Colors.grey.shade800, 'Available'),
                const SizedBox(width: 16),
                legend(Colors.green, 'Selected'),
                const SizedBox(width: 16),
                legend(Colors.red.shade900, 'Booked'),
              ],
            ),
          ),
          // bottom bar: total price and confirm button
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Seats: ${selectedSeats.length}'),
                      const SizedBox(height: 4),
                      Text('Total: Rs. $total',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  // button is disabled (null) when no seat is selected
                  onPressed: selectedSeats.isEmpty
                      ? null
                      : () {
                          final List<String> seatList =
                              selectedSeats.toList()..sort();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TicketScreen(
                                movie: widget.movie,
                                date: widget.date,
                                time: widget.time,
                                seats: seatList,
                                total: total,
                              ),
                            ),
                          );
                        },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// SCREEN 4: TICKET  (final confirmation)
// ===============================================================
class TicketScreen extends StatelessWidget {
  final Movie movie;
  final String date;
  final String time;
  final List<String> seats;
  final int total;

  const TicketScreen({
    super.key,
    required this.movie,
    required this.date,
    required this.time,
    required this.seats,
    required this.total,
  });

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Ticket'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 56),
                const SizedBox(height: 8),
                const Text('Booking Confirmed!',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // coloured top part of ticket
                      Container(
                        height: 110,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [movie.color1, movie.color2]),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(movie.icon, color: Colors.white, size: 36),
                            const SizedBox(height: 6),
                            Text(movie.name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            infoRow('Date', date),
                            infoRow('Time', time),
                            infoRow('Seats', seats.join(', ')),
                            infoRow('Tickets', '${seats.length}'),
                            infoRow('Booking ID', 'MT48291'),
                            const Divider(),
                            infoRow('Total Paid', 'Rs. $total'),
                            const SizedBox(height: 12),
                            // fake barcode: bars with different widths
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(40, (i) {
                                return Container(
                                  width: (i % 3 + 1).toDouble(),
                                  height: 50,
                                  color: Colors.black,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    // go back to the first screen (Home)
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
