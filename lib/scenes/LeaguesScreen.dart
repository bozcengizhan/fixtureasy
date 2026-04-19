import 'package:flutter/material.dart';
import '../services/the_sports_db_service.dart';
import 'SelectionScreen.dart';

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {
  final TheSportsDBService _service = TheSportsDBService();

  List<dynamic> allLeagues = []; // API'den gelen ana liste
  List<dynamic> filteredLeagues = []; // Ekranda gösterilen (filtreli) liste
  bool isLoading = true;
  bool isSearching = false; // Arama çubuğu açık mı kapalı mı?

  final List<Map<String, dynamic>> _masterLeagues = [
    // --- TÜRKİYE ---
    {
      "idLeague": "4351",
      "strLeague": "Turkish Super Lig",
      "strSport": "Soccer",
    },
    {"idLeague": "4610", "strLeague": "Turkish 1. Lig", "strSport": "Soccer"},
    {"idLeague": "4622", "strLeague": "Turkish Cup", "strSport": "Soccer"},

    // --- İNGİLTERE ---
    {
      "idLeague": "4328",
      "strLeague": "English Premier League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4347",
      "strLeague": "English League Championship",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4348",
      "strLeague": "English League One",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4349",
      "strLeague": "English League Two",
      "strSport": "Soccer",
    },
    {"idLeague": "4387", "strLeague": "FA Cup", "strSport": "Soccer"},
    {"idLeague": "4388", "strLeague": "EFL Cup", "strSport": "Soccer"},
    {
      "idLeague": "4390",
      "strLeague": "English Community Shield",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4627",
      "strLeague": "English National League",
      "strSport": "Soccer",
    },

    // --- İSPANYA ---
    {"idLeague": "4335", "strLeague": "Spanish La Liga", "strSport": "Soccer"},
    {
      "idLeague": "4350",
      "strLeague": "Spanish La Liga 2",
      "strSport": "Soccer",
    },
    {"idLeague": "4472", "strLeague": "Copa del Rey", "strSport": "Soccer"},

    // --- ALMANYA ---
    {
      "idLeague": "4331",
      "strLeague": "German Bundesliga",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4352",
      "strLeague": "German 2. Bundesliga",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4353",
      "strLeague": "German 3. Bundesliga",
      "strSport": "Soccer",
    },
    {"idLeague": "4391", "strLeague": "DFB Pokal", "strSport": "Soccer"},

    // --- İTALYA ---
    {"idLeague": "4332", "strLeague": "Italian Serie A", "strSport": "Soccer"},
    {"idLeague": "4357", "strLeague": "Italian Serie B", "strSport": "Soccer"},
    {"idLeague": "4392", "strLeague": "Coppa Italia", "strSport": "Soccer"},

    // --- FRANSA ---
    {"idLeague": "4334", "strLeague": "French Ligue 1", "strSport": "Soccer"},
    {"idLeague": "4358", "strLeague": "French Ligue 2", "strSport": "Soccer"},
    {"idLeague": "4393", "strLeague": "Coupe de France", "strSport": "Soccer"},

    // --- AVRUPA (DİĞER) ---
    {"idLeague": "4337", "strLeague": "Dutch Eredivisie", "strSport": "Soccer"},
    {
      "idLeague": "4569",
      "strLeague": "Dutch Eerste Divisie",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4338",
      "strLeague": "Portuguese Primeira Liga",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4339",
      "strLeague": "Belgian First Division A",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4344",
      "strLeague": "Russian Premier League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4346",
      "strLeague": "Scottish Premiership",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4330",
      "strLeague": "Scottish Championship",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4345",
      "strLeague": "Swiss Super League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4362",
      "strLeague": "Greek Super League",
      "strSport": "Soccer",
    },
    {"idLeague": "4363", "strLeague": "Danish Superliga", "strSport": "Soccer"},
    {
      "idLeague": "4365",
      "strLeague": "Norwegian Eliteserien",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4366",
      "strLeague": "Swedish Allsvenskan",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4368",
      "strLeague": "Austrian Bundesliga",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4372",
      "strLeague": "Polish Ekstraklasa",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4381",
      "strLeague": "Czech First League",
      "strSport": "Soccer",
    },
    {"idLeague": "4382", "strLeague": "Hungarian NB I", "strSport": "Soccer"},
    {
      "idLeague": "4398",
      "strLeague": "Ukrainian Premier League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4367",
      "strLeague": "Finnish Veikkausliiga",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4373",
      "strLeague": "Israeli Premier League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4364",
      "strLeague": "Irish Premier Division",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4369",
      "strLeague": "Croatian First Football League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4370",
      "strLeague": "Serbian SuperLiga",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4371",
      "strLeague": "Slovak Super Liga",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4383",
      "strLeague": "Bulgarian First League",
      "strSport": "Soccer",
    },
    {"idLeague": "4384", "strLeague": "Romanian Liga I", "strSport": "Soccer"},

    // --- AMERİKA (KUZEY & GÜNEY) ---
    {"idLeague": "4340", "strLeague": "American MLS", "strSport": "Soccer"},
    {
      "idLeague": "4341",
      "strLeague": "Brazilian Serie A",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4426",
      "strLeague": "Brazilian Serie B",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4343",
      "strLeague": "Argentine Primera Division",
      "strSport": "Soccer",
    },
    {"idLeague": "4399", "strLeague": "Mexican Liga MX", "strSport": "Soccer"},
    {
      "idLeague": "4401",
      "strLeague": "Colombian Primera A",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4425",
      "strLeague": "Chilean Primera Division",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4422",
      "strLeague": "Uruguayan Primera Division",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4423",
      "strLeague": "Paraguayan Primera Division",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4424",
      "strLeague": "Ecuadorian Serie A",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4545",
      "strLeague": "Peru Primera Division",
      "strSport": "Soccer",
    },

    // --- ASYA & OKYANUSYA ---
    {
      "idLeague": "4342",
      "strLeague": "Saudi Arabian Pro League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4359",
      "strLeague": "Chinese Super League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4356",
      "strLeague": "Australian A-League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4360",
      "strLeague": "Japanese J1 League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4361",
      "strLeague": "Japanese J2 League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4374",
      "strLeague": "Indian Super League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4380",
      "strLeague": "South Korean K League 1",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4480",
      "strLeague": "Qatar Stars League",
      "strSport": "Soccer",
    },
    {"idLeague": "4481", "strLeague": "UAE Pro League", "strSport": "Soccer"},
    {"idLeague": "4483", "strLeague": "Thai League 1", "strSport": "Soccer"},

    // --- AFRIKA ---
    {
      "idLeague": "4336",
      "strLeague": "Africa Cup of Nations",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4375",
      "strLeague": "South African Premier Division",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4376",
      "strLeague": "Egyptian Premier League",
      "strSport": "Soccer",
    },
    {"idLeague": "4378", "strLeague": "Moroccan Botola", "strSport": "Soccer"},
    {
      "idLeague": "4379",
      "strLeague": "Tunisian Ligue Professionnelle 1",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4395",
      "strLeague": "Algerian Ligue Professionnelle 1",
      "strSport": "Soccer",
    },

    // --- ULUSLARARASI KUPALAR ---
    {
      "idLeague": "4354",
      "strLeague": "UEFA Champions League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4355",
      "strLeague": "UEFA Europa League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4842",
      "strLeague": "UEFA Conference League",
      "strSport": "Soccer",
    },
    {"idLeague": "4327", "strLeague": "FIFA World Cup", "strSport": "Soccer"},
    {"idLeague": "4329", "strLeague": "Copa America", "strSport": "Soccer"},
    {
      "idLeague": "4389",
      "strLeague": "UEFA Nations League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4394",
      "strLeague": "Copa Libertadores",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4400",
      "strLeague": "Copa Sudamericana",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4415",
      "strLeague": "AFC Champions League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4417",
      "strLeague": "CONCACAF Champions League",
      "strSport": "Soccer",
    },
    {
      "idLeague": "4421",
      "strLeague": "FIFA Club World Cup",
      "strSport": "Soccer",
    },
    {"idLeague": "4397", "strLeague": "UEFA Super Cup", "strSport": "Soccer"},
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLeagues();
    print(allLeagues);
  }

  Future<void> _loadLeagues() async {
    setState(() => isLoading = true);

    // API'ye gitmek yerine manuel listemizi ana listeye atıyoruz
    setState(() {
      allLeagues = _masterLeagues;
      filteredLeagues = _masterLeagues;
      isLoading = false;
    });
  }

  // Arama mantığını 'contains' yerine daha esnek hale getirelim
  void _performSearch() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredLeagues = allLeagues;
      } else {
        filteredLeagues = allLeagues
            .where(
              (league) =>
                  league['strLeague'].toString().toLowerCase().contains(query),
            )
            .toList();
      }
      isSearching = false; // Arama bitince TextField kapansın demiştin
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // EĞER ARAMA MODUNDAYSA TEXTFIELD, DEĞİLSE BAŞLIK GÖSTER
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Lig ara... (Örn: Premier League)",
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  _performSearch();
                  setState(
                    () => isSearching = false,
                  ); // Enter'a basınca kapansın
                },
              )
            : const Text("Ligler"),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  // Arama butonuna tekrar basıldıysa (Kapatma modu)
                  _performSearch(); // Aramayı yap
                  isSearching = false; // TextField'ı kapat
                } else {
                  // Arama butonuna ilk kez basıldıysa (Açma modu)
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : filteredLeagues.isEmpty
          ? const Center(child: Text("Lig bulunamadı."))
          : ListView.builder(
              itemCount: filteredLeagues.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final league = filteredLeagues[index];
                return _buildLeagueCard(league);
              },
            ),
    );
  }

  Widget _buildLeagueCard(dynamic league) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.emoji_events, color: Colors.white, size: 20),
        ),
        title: Text(
          league['strLeague'] ?? "Bilinmeyen Lig",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          league['strSport'] ?? "",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.white24,
        ),
        onTap: () {
          final String? idStr = league['idLeague'];
          final int leagueId =
              int.tryParse(idStr ?? '') ?? 0; // Hatalıysa 0 ver

          if (leagueId != 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectionScreen(
                  leagueId: leagueId,
                  leagueName: league['strLeague'] ?? "Bilinmeyen Lig",
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
