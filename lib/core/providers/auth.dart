part of com.pogo_check_list_ota_labs.app.providers;

class AuthStatus {
  const AuthStatus({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;

  AuthStatus copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) => AuthStatus(
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}

class AuthNotifier extends Notifier<AuthStatus> {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  AuthStatus build() {
    GoTrueClient auth = Supabase.instance.client.auth;
    _authSubscription = auth.onAuthStateChange.listen((AuthState authState) {
      bool isAuthenticated = authState.session != null;
      if (state.isAuthenticated != isAuthenticated) {
        state = state.copyWith(isAuthenticated: isAuthenticated);
      }
    });
    ref.onDispose(() => _authSubscription?.cancel());
    return AuthStatus(isAuthenticated: auth.currentSession != null);
  }

  Future<void> signIn(String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: hardcodedEmail,
        password: password,
      );
      state = const AuthStatus(isAuthenticated: true);
    } on AuthException catch (e) {
      state = AuthStatus(errorMessage: _describeAuthError(e));
    } catch (e) {
      state = const AuthStatus(
        errorMessage: 'Ocurrió un error inesperado. Intenta de nuevo.',
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await Supabase.instance.client.auth.signOut();
      state = const AuthStatus();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo cerrar sesión. Intenta de nuevo.',
      );
    }
  }

  void clearError() {
    if (state.errorMessage != null) state = state.copyWith(clearError: true);
  }

  /// Supabase devuelve los mensajes en inglés; se traducen los casos
  /// conocidos y el resto cae en un mensaje genérico.
  String _describeAuthError(AuthException error) {
    if (error is AuthRetryableFetchException) {
      return 'Sin conexión. Revisa tu internet e intenta de nuevo.';
    }
    if (error.code == 'invalid_credentials') {
      return 'Contraseña incorrecta.';
    }
    if (error.code == 'over_request_rate_limit') {
      return 'Demasiados intentos. Espera un momento e intenta de nuevo.';
    }
    return 'No se pudo iniciar sesión. Intenta de nuevo.';
  }
}

final NotifierProvider<AuthNotifier, AuthStatus> authProvider =
    NotifierProvider<AuthNotifier, AuthStatus>(AuthNotifier.new);
