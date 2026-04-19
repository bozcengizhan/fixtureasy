import 'package:flutter/material.dart';
import '../services/the_sports_db_service.dart';
import '../models/the_sports_event_model.dart';

class LeagueFixtureScreen extends StatefulWidget {
  final int leagueId;
  final String leagueName;

  const LeagueFixtureScreen({
    super.key,
    required this.leagueId,
    required this.leagueName,
  });

  @override
  State<LeagueFixtureScreen> createState() => _LeagueFixtureScreenState();
}

class _LeagueFixtureScreenState extends State<LeagueFixtureScreen> {
  final TheSportsDBService _service = TheSportsDBService();

  List<TheSportsEvent> allEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllEvents();
  }

  Future<void> _loadAllEvents() async {
    // mounted kontrolü, sayfa kapanmışsa setstate yapılmasını engeller
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      // 1. Paralel istekleri yapıyoruz
      final results = await Future.wait([
        _service.getLastResults(widget.leagueId),
        _service.getNextEvents(widget.leagueId),
      ]);

      // 2. Verilerin null gelme ihtimaline karşı boş liste atıyoruz
      final List<dynamic> pastRaw = results[0] ?? [];
      final List<dynamic> nextRaw = results[1] ?? [];

      // 3. Modelleri map'lerken hata riskini azaltmak için try-catch veya null kontrolü
      final List<TheSportsEvent> pastEvents = pastRaw
          .map((e) => TheSportsEvent.fromJson(e))
          .toList();
      final List<TheSportsEvent> nextEvents = nextRaw
          .map((e) => TheSportsEvent.fromJson(e))
          .toList();

      if (mounted) {
        setState(() {
          // Önce gelecek maçlar (nextEvents), sonra geçmiş maçlar (pastEvents)
          allEvents = [...nextEvents, ...pastEvents];
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Maçlar yüklenirken hata oluştu: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.leagueName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllEvents,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : allEvents.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadAllEvents,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                itemCount: allEvents.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final event = allEvents[index];
                  return _buildMatchCard(event);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 60, color: Colors.white24),
          const SizedBox(height: 10),
          const Text("Bu lig için güncel maç verisi bulunamadı."),
        ],
      ),
    );
  }

  Widget _buildMatchCard(TheSportsEvent event) {
    // API'den skorlar bazen 'null' yerine boş string gelebilir veya null olabilir
    bool isPlayed =
        event.intHomeScore != null && event.intHomeScore!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          children: [
            // Ev Sahibi
            Expanded(
              flex: 3,
              child: Text(
                event.strHomeTeam,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),

            // Skor veya VS Alanı
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    isPlayed
                        ? "${event.intHomeScore} - ${event.intAwayScore}"
                        : "VS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isPlayed ? Colors.blueAccent : Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Tarihi daha okunaklı yapalım
                  Text(
                    event.dateEvent,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Deplasman
            Expanded(
              flex: 3,
              child: Text(
                event.strAwayTeam,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
