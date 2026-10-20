
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../service/auth_service.dart';
import 'package:projeto_patrimonio/widgets/botaoprincipal.dart';

class EsqueciSenhaPage extends StatefulWidget {
  const EsqueciSenhaPage({super.key});

  @override
  State<EsqueciSenhaPage> createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage> {
  final AuthService authService = Get.find<AuthService>();

  final emailCtrl = TextEditingController();
  final codigoCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final confirmarSenhaCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  int etapa = 0;
  bool carregando = false;
  bool ocultarSenha = true;
  String? emailValidado;

  @override
  void dispose() {
    emailCtrl.dispose();
    codigoCtrl.dispose();
    senhaCtrl.dispose();
    confirmarSenhaCtrl.dispose();
    super.dispose();
  }

  InputDecoration decoracao(
    String hint,
    IconData icone, {
    Widget? sufixo,
  }) {
    final borda = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borda),
    );

    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icone, color: Colors.black),
      suffixIcon: sufixo,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      enabledBorder: borda,
      focusedBorder: borda.copyWith(
        borderSide: const BorderSide(
          color: AppColors.azul,
          width: 1.5,
        ),
      ),
      border: borda,
    );
  }

  void mostrarMensagem(String titulo, String mensagem) {
    Get.snackbar(
      titulo,
      mensagem,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> solicitarCodigo() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    try {
      final email = emailCtrl.text.trim();

      final response = await authService.forgotPassword(email);

      if (!mounted) return;

      if (response.isOk) {
        emailValidado = email;

        setState(() => etapa = 1);

        mostrarMensagem(
          'Solicitação enviada',
          'Confira seu e-mail para obter o código.',
        );
      } else {
        mostrarMensagem(
          'Não foi possível solicitar',
          response.statusText ?? 'Tente novamente.',
        );
      }
    } catch (e) {
      mostrarMensagem(
        'Erro',
        'Não foi possível conectar ao servidor.',
      );
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  Future<void> validarCodigo() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    try {
      final response = await authService.verifyCode(
        emailValidado!,
        codigoCtrl.text.trim(),
      );

      if (!mounted) return;

      if (response.isOk) {
        setState(() => etapa = 2);
      } else {
        mostrarMensagem(
          'Código inválido',
          response.statusText ?? 'Confira o código e tente novamente.',
        );
      }
    } catch (e) {
      mostrarMensagem(
        'Erro',
        'Não foi possível validar o código.',
      );
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  Future<void> redefinirSenha() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => carregando = true);

    try {
      final response = await authService.resetPassword(
        emailValidado!,
        codigoCtrl.text.trim(),
        senhaCtrl.text,
      );

      if (!mounted) return;

      if (response.isOk) {
        mostrarMensagem(
          'Senha alterada',
          'Agora você pode entrar com sua nova senha.',
        );

        Get.back();
      } else {
        mostrarMensagem(
          'Não foi possível alterar a senha',
          response.statusText ?? 'Verifique o código e tente novamente.',
        );
      }
    } catch (e) {
      mostrarMensagem(
        'Erro',
        'Não foi possível redefinir a senha.',
      );
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  Widget campoEmail() {
    return TextFormField(
      controller: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: decoracao('E-mail cadastrado', Icons.mail_outline),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Informe seu e-mail';
        }

        if (!GetUtils.isEmail(valor.trim())) {
          return 'E-mail inválido';
        }

        return null;
      },
    );
  }

  Widget campoCodigo() {
    return TextFormField(
      controller: codigoCtrl,
      keyboardType: TextInputType.number,
      decoration: decoracao('Código recebido', Icons.pin_outlined),
      validator: (valor) {
        if (valor == null || valor.trim().isEmpty) {
          return 'Informe o código recebido';
        }

        return null;
      },
    );
  }

  Widget campoSenha() {
    return TextFormField(
      controller: senhaCtrl,
      obscureText: ocultarSenha,
      decoration: decoracao(
        'Nova senha',
        Icons.lock_outline,
        sufixo: IconButton(
          onPressed: () {
            setState(() => ocultarSenha = !ocultarSenha);
          },
          icon: Icon(
            ocultarSenha
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Informe a nova senha';
        }

        if (valor.length < 8) {
          return 'A senha deve ter pelo menos 8 caracteres';
        }

        return null;
      },
    );
  }

  Widget campoConfirmarSenha() {
    return TextFormField(
      controller: confirmarSenhaCtrl,
      obscureText: ocultarSenha,
      decoration: decoracao(
        'Confirme a nova senha',
        Icons.lock_reset_outlined,
      ),
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Confirme sua senha';
        }

        if (valor != senhaCtrl.text) {
          return 'As senhas não coincidem';
        }

        return null;
      },
    );
  }

  String get titulo {
    switch (etapa) {
      case 1:
        return 'Validar código';
      case 2:
        return 'Nova senha';
      default:
        return 'Recuperar senha';
    }
  }

  String get descricao {
    switch (etapa) {
      case 1:
        return 'Informe o código enviado para seu e-mail.';
      case 2:
        return 'Digite e confirme sua nova senha.';
      default:
        return 'Informe seu e-mail para iniciar a recuperação.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: AppColors.fundo,
        title: const Text('Recuperação de senha'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_reset_outlined,
                      size: 72,
                      color: AppColors.azul,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      descricao,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    if (etapa == 0) campoEmail(),

                    if (etapa == 1) ...[
                      Text(
                        'E-mail: ${emailValidado ?? ''}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      campoCodigo(),
                    ],

                    if (etapa == 2) ...[
                      campoSenha(),
                      const SizedBox(height: 20),
                      campoConfirmarSenha(),
                    ],

                    const SizedBox(height: 24),

                    BotaoPrincipal(
                      texto: const [
                        'Enviar código',
                        'Validar código',
                        'Redefinir senha',
                      ][etapa],
                      carregando: carregando,
                      onPressed: () {
                        switch (etapa) {
                          case 0:
                            solicitarCodigo();
                            break;
                          case 1:
                            validarCodigo();
                            break;
                          case 2:
                            redefinirSenha();
                            break;
                        }
                      },
                    ),

                    if (etapa == 1) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: carregando
                            ? null
                            : () {
                                setState(() => etapa = 0);
                              },
                        child: const Text('Voltar'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
