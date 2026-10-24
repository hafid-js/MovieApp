import 'package:flutter/material.dart';
import 'package:film_app/core/constants/app_colors.dart';
import 'package:film_app/features/mapbox/services/direction_service.dart';

class RouteInfoCard extends StatelessWidget {
  final RouteResult route;
  final bool isSimulating;
  final VoidCallback onClear;
  final VoidCallback onDrive;
  final String remainingDistance;
  final String remainingDuration;
  const RouteInfoCard({
    super.key,
    required this.route,
    required this.isSimulating,
    required this.onClear,
    required this.onDrive,
    this.remainingDistance = '',
    this.remainingDuration = ''
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary, blurRadius:12)],
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_car, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSimulating && remainingDuration.isNotEmpty ? remainingDuration : route.durationText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              Text(
                isSimulating && remainingDistance.isNotEmpty ? remainingDistance : route.distanceText,
                style: TextStyle(color: AppColors.secondary),
              )
            ],
          )),
                    TextButton.icon(onPressed: onClear, label: const Text('Clear', style: TextStyle(color:Colors.white),), icon: Icon(Icons.close, color: Colors.white, size: 16,),),
          TextButton.icon(onPressed: onDrive, label: Text(isSimulating ? 'Stop' : 'Drive',style: TextStyle(color:Colors.white),), icon: Icon(isSimulating ? Icons.stop : Icons.directions_car,color: Colors.white, size: 16,),),

        ],
      ),
    );
  }
}