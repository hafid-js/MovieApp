import 'package:flutter/material.dart';
import 'package:film_app/features/cinema/models/cinema.dart';

class CinemaPopup extends StatelessWidget {
  final Cinema cinema;
  final VoidCallback onClose;
  final VoidCallback onViewDetail;

  const CinemaPopup({
    super.key,
    required this.cinema,
    required this.onClose,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(cinema.name, style: theme.textTheme.titleMedium),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 20),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${cinema.brand} - ${cinema.city}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _InfoRow(
                      icon: Icons.location_on_outlined,
                      text: cinema.address,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _InfoRow(
                      icon: Icons.access_time_outlined,
                      text: cinema.openHours,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onViewDetail,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Detail Cinema',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 5),
        Expanded(
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ],
    );
  }
}
