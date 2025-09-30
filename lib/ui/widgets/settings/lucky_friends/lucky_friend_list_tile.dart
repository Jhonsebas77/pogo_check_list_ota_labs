part of com.pogo_check_list_ota_labs.app.widgets;

class LuckyFriendListTile extends StatelessWidget {
  const LuckyFriendListTile({required this.friend, super.key});

  final LuckyFriend friend;

  Widget _buildAvatar(BuildContext context) {
    if (friend.avatarUrl != null && friend.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(friend.avatarUrl!),
      );
    }
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset(
          'assets/bg_holder_pokemon.png',
          height: 64,
          width: 64,
          fit: BoxFit.fill,
        ),
        const Center(
          child: Icon(
            Icons.connect_without_contact_rounded,
            color: Color(0xFFDA7B28),
            size: 50,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(50),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildAvatar(context),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      friend.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDA7B28),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 2,
                  children: List<Widget>.generate(
                    4,
                    (_) => const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.yellow,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        if (friend.pokemonOffer == null)
          const Icon(Icons.catching_pokemon, size: 50, color: Colors.grey),
        if (friend.pokemonOffer != null)
          if (friend.pokemonOffer?.isShiny ?? false)
            Image.asset(
              'assets/pokedex_sprites_shiny/${friend.pokemonOffer?.id}.png',
              height: 50,
              width: 50,
            )
          else
            Image.asset(
              'assets/pokedex_sprites/${friend.pokemonOffer?.id}.png',
              height: 50,
              width: 50,
            ),
        const Icon(Icons.wifi_protected_setup_sharp),
        if (friend.pokemonWanted == null)
          const Icon(Icons.catching_pokemon, size: 50, color: Colors.grey),
        if (friend.pokemonWanted != null)
          if (friend.pokemonWanted?.isShiny ?? false)
            Image.asset(
              'assets/pokedex_sprites_shiny/${friend.pokemonWanted?.id}.png',
              height: 50,
              width: 50,
            )
          else
            Image.asset(
              'assets/pokedex_sprites/${friend.pokemonWanted?.id}.png',
              height: 50,
              width: 50,
            ),
        const SizedBox(width: 16),
      ],
    ),
  );
}
