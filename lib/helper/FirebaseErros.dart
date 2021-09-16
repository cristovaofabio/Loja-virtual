String getErrorString(String code){
  switch (code) {
    case 'weak-password':
      return 'A sua senha é muito fraca.';
 
    case 'invalid-email':
      return 'Seu e-mail é inválido.';
 
    case 'account-exists-with-different-credential':
      return 'O e-mail já está sendo utilizado em outra conta.';

    case 'email-already-in-use':
      return 'O e-mail já está sendo utilizado em outra conta.';
 
    case 'invalid-credential':
      return 'O seu e-mail é inválido.';
 
    case 'wrong-password':
      return 'A sua senha está incorreta.';
 
    case 'user-not-found':
      return 'Não existe usuário com esse endereço de e-mail.';
 
    case 'user-disabled':
      return 'Este usuário foi desabilitado.';
 
    case 'operation-not-allowed':
      return 'Erro na conexão. Tente novamente mais tarde!';

    case 'too-many-requests':
      return 'Muitas requisições! Tente novamente mais tarde ou use outra conta.';
 
    default:
      return 'Ocorreu um erro, verifique os seus dados e tente novamente.';
  }
}