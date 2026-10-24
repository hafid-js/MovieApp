import 'package:film_app/core/constants/app_colors.dart';
import 'package:film_app/features/reminder/screens/reminder_form_dialog.dart';
import 'package:flutter/material.dart';

class FilmItem extends StatelessWidget {
  final String title;
  final int episode;
  final String cinemaId;
  final String cinema;
  final String director;
  final String image;
  final VoidCallback onTap;

  const FilmItem({
    super.key,
    required this.title,
    required this.episode,
    required this.cinemaId,
    required this.cinema,
    required this.director,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              height: 100,
              width: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Colors.black12,
                child: SizedBox(
                  height: 100,
                  width: 90,
                  child: Icon(Icons.movie),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "Director: $director",
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "View Detail",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              showReminderForm(
                context,
                cinemaId: cinemaId,
                cinemaName: cinema,
                filmEpisodeId: episode,
                filmTitle: title,
              );
            },
            child: Icon(Icons.notifications, color: Colors.white54,),
          ),
        ],
      ),
    );
  }
}
