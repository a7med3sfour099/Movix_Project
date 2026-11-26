class EditProfileState {
  final String imagePath;
  final bool isLoading;
  final String? error;

  const EditProfileState({
    this.imagePath = '',
    this.isLoading = false,
    this.error,
  });

  EditProfileState copyWith({
    String? imagePath,
    bool? isLoading,
    String? error,
  }) {
    return EditProfileState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
