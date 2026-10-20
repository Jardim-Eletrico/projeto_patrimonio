
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_controler.dart';
import '../../core/app_colors.dart';
import '../../model/usuario.dart';
import 'package:projeto_patrimonio/widgets/botaoprincipal.dart';

class CadastroAdministradorPage extends StatefulWidget {
  const CadastroAdministradorPage({super.key});

  @override
  State<CadastroAdministradorPage> createState() =>
      _CadastroAdministradorPageState();
}

class _CadastroAdministradorPageState
    extends State<CadastroAdministradorPage> {
  final controller = Get.find<LoginCongtroler>();

  final formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  final departamentoCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();

  bool ocultarSenha = true;

  InputDecoration _decoracao(
    String hint,
    Widget icone, {
    Widget? sufixo,
  }) {
    final borda = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borda),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.hint),
      prefixIcon: icone,
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

  Widget _rotulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _campo({
    required String rotulo,
    required String hint,
    required IconData icone,
    required TextEditingController textController,
    TextInputType teclado = TextInputType.text,
    String? Function(String?)? validar,
    TextInputAction acao = TextInputAction.next,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _rotulo(rotulo),
        TextFormField(
          controller: textController,
          keyboardType: teclado,
          textInputAction: acao,
          decoration: _decoracao(
            hint,
            Icon(icone, color: Colors.black),
          ),
          validator: validar ??
              (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Informe $rotulo';
                }
                return null;
              },
        ),
      ],
    );
  }

  Future<void> _cadastrar() async {
    if (!formKey.currentState!.validate()) return;

    final usuario = Usuario(
      nome: nomeCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      cpf: cpfCtrl.text.trim(),
      telefone: telefoneCtrl.text.trim(),
      departamento: departamentoCtrl.text.trim(),
      role: 'admin',
      matricula: '',
    );

    final sucesso = await controller.cadastrarAdm(
      usuario,
      senhaCtrl.text,
    );

    if (sucesso && mounted) {
      Get.back();
    }
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    emailCtrl.dispose();
    cpfCtrl.dispose();
    telefoneCtrl.dispose();
    departamentoCtrl.dispose();
    senhaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        backgroundColor: AppColors.fundo,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Cadastrar administrador'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 72,
                      color: AppColors.azul,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Novo administrador',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Preencha os dados para cadastrar um administrador.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.hint,
                      ),
                    ),
                    const SizedBox(height: 28),

                    _campo(
                      rotulo: 'Nome',
                      hint: 'Nome completo',
                      icone: Icons.person_outline,
                      textController: nomeCtrl,
                    ),
                    const SizedBox(height: 20),

                    _campo(
                      rotulo: 'E-mail',
                      hint: 'E-mail',
                      icone: Icons.mail_outline,
                      textController: emailCtrl,
                      teclado: TextInputType.emailAddress,
                      validar: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe o e-mail';
                        }
                        if (!GetUtils.isEmail(valor.trim())) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    _campo(
                      rotulo: 'CPF',
                      hint: 'CPF',
                      icone: Icons.badge_outlined,
                      textController: cpfCtrl,
                      teclado: TextInputType.number,
                    ),
                    const SizedBox(height: 20),

                    _campo(
                      rotulo: 'Telefone',
                      hint: 'Telefone para contato',
                      icone: Icons.phone_outlined,
                      textController: telefoneCtrl,
                      teclado: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    _campo(
                      rotulo: 'Departamento',
                      hint: 'Ex.: Coordenação Pedagógica',
                      icone: Icons.business_outlined,
                      textController: departamentoCtrl,
                    ),
                    const SizedBox(height: 20),

                    _rotulo('Senha'),
                    TextFormField(
                      controller: senhaCtrl,
                      obscureText: ocultarSenha,
                      textInputAction: TextInputAction.done,
                      decoration: _decoracao(
                        'Crie uma senha',
                        const Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        ),
                        sufixo: IconButton(
                          icon: Icon(
                            ocultarSenha
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.hint,
                          ),
                          onPressed: () {
                            setState(() {
                              ocultarSenha = !ocultarSenha;
                            });
                          },
                        ),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.isEmpty) {
                          return 'Informe a senha';
                        }
                        if (valor.length < 8) {
                          return 'A senha deve ter pelo menos 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    Obx(
                      () => BotaoPrincipal(
                        texto: 'Cadastrar administrador',
                        carregando: controller.carregando.value,
                        onPressed: _cadastrar,
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.laranja,
                          side: const BorderSide(
                            color: AppColors.laranja,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
