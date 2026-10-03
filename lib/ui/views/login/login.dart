part of com.pogo_check_list_ota_labs.app.views;

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String _appName = '...';
  String _version = '...';
  String _buildNumber = '...';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appName = info.appName;
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  void _handleSignIn() {
    if (_passwordController.text.isEmpty) return;
    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();
    ref.read(authProvider.notifier).signIn(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    AuthStatus auth = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildForm(auth),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Column(
    children: <Widget>[
      Container(
        width: 128,
        height: 128,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.circle,
        ),
        child: Image.asset('assets/splash.png', fit: BoxFit.contain),
      ),
      const SizedBox(height: 24),
      Text(
        _appName,
        textAlign: TextAlign.center,
        style: Headings.mH1.copyWith(color: Colors.white),
      ),
      const SizedBox(height: 4),
      Text(
        'By Ota_Labs $_version($_buildNumber)',
        style: Paragraphs.disclaimer.copyWith(color: Colors.white70),
      ),
    ],
  );

  Widget _buildForm(AuthStatus auth) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Iniciar sesión',
          style: Headings.mH3.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 16),
        _buildUserDisplay(),
        const SizedBox(height: 16),
        _buildPasswordInput(auth),
        if (auth.errorMessage != null) ...<Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                const Icon(Icons.error_outline, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    auth.errorMessage!,
                    style: Paragraphs.smallSemiBold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        _buildActionButton(auth),
      ],
    ),
  );

  Widget _buildUserDisplay() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(32),
    ),
    child: Row(
      children: <Widget>[
        const Icon(Icons.person_rounded, color: Colors.white70),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Entrenador',
                style: Paragraphs.disclaimer.copyWith(color: Colors.white70),
              ),
              Text(
                hardcodedEmail.split('@').first,
                overflow: TextOverflow.ellipsis,
                style: Paragraphs.mediumSemiBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildPasswordInput(AuthStatus auth) => TextField(
    controller: _passwordController,
    obscureText: _obscureText,
    enabled: !auth.isLoading,
    style: const TextStyle(color: Colors.white),
    cursorColor: Colors.white,
    textInputAction: TextInputAction.go,
    decoration: inputDecoration(
      context,
      label: 'Contraseña',
      icon: Icons.lock_rounded,
    ).copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_rounded
              : Icons.visibility_rounded,
          color: Colors.white70,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
    ),
    onChanged: (_) => ref.read(authProvider.notifier).clearError(),
    onSubmitted: (_) => _handleSignIn(),
  );

  Widget _buildActionButton(AuthStatus auth) => ElevatedButton.icon(
    onPressed: auth.isLoading ? null : _handleSignIn,
    icon:
        auth.isLoading
            ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            )
            : const Icon(Icons.catching_pokemon_rounded),
    label: Text(auth.isLoading ? 'Ingresando...' : 'Ingresar'),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      disabledBackgroundColor: Theme.of(
        context,
      ).colorScheme.secondary.withAlpha(120),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
