class AuthResponseDto {
  static fromEntity(user, token) {
    return {
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        profile: user.profile,
        createdAt: user.createdAt,
      },
      token
    };
  }
}

module.exports = AuthResponseDto;
