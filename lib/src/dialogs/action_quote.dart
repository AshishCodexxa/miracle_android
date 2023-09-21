import 'package:flutter/material.dart';
import 'package:miracle/src/data/model/quote.dart';
import 'package:miracle/src/data/network/dio_client.dart';
import 'package:miracle/src/utils/common.dart';
import 'package:miracle/src/utils/quote_utils.dart';

class ActionQuoteDialog extends StatelessWidget {
  const ActionQuoteDialog({
    Key? key,
    required this.quote,
    this.collectionId = 0,
    this.hideCollection = false,
    this.isFavorite = false,
    this.isOwnQuote = false,
    this.hideFav = false,
  }) : super(key: key);

  final Quote quote;
  final bool hideCollection;
  final bool hideFav;
  final bool isFavorite;
  final bool isOwnQuote;
  final int collectionId;

  @override
  Widget build(BuildContext context) {
    onOptionSelected(CollectionAction action) {
      switch (action) {
        case CollectionAction.addQuoteToCollection:
          Navigator.of(context).pop();
          showCollections(context, quoteId: quote.id);
          break;
        case CollectionAction.shareQuote:
          share(quote.quote);
          break;
        case CollectionAction.editQuote:
          addQuoteDialog(context, quote);
          break;
        case CollectionAction.removeFavoriteQuote:
          Navigator.of(context).pop(true);
          break;
        case CollectionAction.saveToFavorite:
          DioClient().addFavorite(quote.id).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Added to favorite'),
                duration: Duration(seconds: 3),
              ),
            );
            Navigator.of(context).pop();
          });
          break;
        case CollectionAction.removeQuote:
          Navigator.of(context).pop(true);
          break;
        case CollectionAction.copyQuote:
          copyText(context, quote.quote);
          break;
        default:
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hideCollection)
          ListTile(
            onTap: () {
              onOptionSelected(CollectionAction.addQuoteToCollection);
            },
            title: const Text(
              'Add to Collection',
            ),
          ),
        if (!hideFav)
          ListTile(
            onTap: () {
              onOptionSelected(CollectionAction.saveToFavorite);
            },
            title: const Text(
              'Save to Favorites',
            ),
          ),
        ListTile(
          onTap: () {
            onOptionSelected(CollectionAction.shareQuote);
          },
          title: const Text(
            'Share Quote',
          ),
        ),
        if (isOwnQuote)
          ListTile(
            onTap: () {
              onOptionSelected(CollectionAction.copyQuote);
            },
            title: const Text(
              'Copy Quote',
            ),
          ),
        ListTile(
          onTap: () {
            if (isFavorite) {
              onOptionSelected(CollectionAction.removeFavoriteQuote);
            } else {
              onOptionSelected(CollectionAction.removeQuote);
            }
          },
          title: const Text(
            'Remove',
          ),
        ),
      ],
    );
  }
}
