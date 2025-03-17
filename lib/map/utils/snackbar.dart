import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yandex_maps/map/utils/extension_utils.dart';


bool showSnackBar(
    BuildContext? context,
    Map<String, dynamic> hotelData,
    bool isHotel,
    dynamic requestData
    ) {
  final isShown = context?.let((it) {
    // Очистка предыдущих SnackBar
    ScaffoldMessenger.of(it).clearSnackBars();

    // Показ нового SnackBar
    final snackBar = _getSnackBar(it, hotelData, isHotel, requestData);
    ScaffoldMessenger.of(it).showSnackBar(snackBar);
    return true;
  });
  return isShown ?? false;
}

SnackBar _getSnackBar(
    BuildContext context,
    Map<String, dynamic> hotelData,
    bool isHotel,
    Map? requestData
    ) {
  final hotelPrice = !isHotel
      ? hotelData['tour_price']
      : hotelData['rates'][0]['daily_prices'][0];
  print("hotelPrice=$hotelPrice");
  final hotelName =!isHotel
      ? hotelData['hotel_name']
      : hotelData['hotel']['name'];

  final hotelCategory = !isHotel
      ? hotelData['hotel_category'] ?? 0
      : hotelData['hotel']['star_rating'];
  final hotelPhoto = !isHotel
      ? hotelData['hotel_preview'] ?? hotelData['hotel_pics'][0]['x290x135']
      : hotelData['hotel']['images'][0].replaceAll("{size}", 'x500');

  return SnackBar(
    showCloseIcon: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    closeIconColor: Theme.of(context).colorScheme.secondary,
    behavior: SnackBarBehavior.floating,
    content: Row(
      children: [
        // Фото отеля
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: hotelPhoto,
            height: 90,
            width: 100,
            // Фиксированная ширина изображения
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => SvgPicture.asset(
              'assets/tour_img/icon_nophoto.svg',
              fit: BoxFit.cover,
              height: 90,
              width: 100, // Совпадает с шириной изображения
            ),
          ),
        ),
        const SizedBox(width: 2.0),
        // Текстовая информация
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: List.generate(
                  hotelCategory,
                  (starIndex) => const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.orange,
                  ),
                ),
              ),
              Text(
                hotelName,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2, // Позволяет отображать до 2 строк
                overflow: TextOverflow.ellipsis,
              ),

            ],
          ),
        )
      ],
    ),
  );
}
