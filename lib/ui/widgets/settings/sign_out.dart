part of com.pogo_check_list_ota_labs.app.widgets;

class SignOutMenuItem extends ConsumerWidget {
  const SignOutMenuItem({super.key});

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Salir'),
              ),
            ],
          ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(authProvider.notifier).signOut();
    if (!context.mounted) return;
    String? error = ref.read(authProvider).errorMessage;
    if (error != null) showErrorSnackBar(context, error);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(32),
    ),
    child: ListTile(
      title: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
      leading: const Icon(Icons.logout_rounded, color: Colors.white),
      enabled:
          !ref.watch(authProvider.select((AuthStatus auth) => auth.isLoading)),
      onTap: () => _confirmSignOut(context, ref),
    ),
  );
}
