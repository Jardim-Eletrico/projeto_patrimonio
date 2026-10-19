import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controler.dart';
import '../../core/app_colors.dart';
import 'package:projeto_patrimonio/widgets/botaoprincipal.dart';

class LoginPage extends GetView<LoginCongtroler> {
  const LoginPage({super.key});

  InputDecoration _decoracao(String hint, Widget icone, {Widget? sufixo}) {
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
        borderSide: const BorderSide(color: AppColors.azul, width: 1.5),
      ),
      border: borda,
    );
  }

  Widget _rotulo(String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/logoflutter.png',
                      height: 80,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.inventory_2_outlined, size: 80),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Entrar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 28),

                    _rotulo('E-mail'),
                    TextFormField(
                      controller: controller.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _decoracao(
                        'E-mail',
                        const Icon(Icons.mail_outline, color: Colors.black),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Informe o e-mail';
                        }
                        if (!GetUtils.isEmail(v.trim())) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    _rotulo('Senha'),
                    Obx(() => TextFormField(
                          controller: controller.senhaCtrl,
                          obscureText: controller.ocultarSenha.value,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => controller.entrar(),
                          decoration: _decoracao(
                            'Senha',
                            const Icon(Icons.lock_outline, color: Colors.black),
                            sufixo: IconButton(
                              icon: Icon(
                                controller.ocultarSenha.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.hint,
                              ),
                              onPressed: controller.alterarSenha,
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Informe a senha'
                              : null,
                        )),
                    const SizedBox(height: 16),

                    Obx(() => controller.erro.value.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              controller.erro.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          )),



                        Obx(
                          () => BotaoPrincipal(
                            texto: 'Entrar',
                            carregando: controller.carregando.value,
                            onPressed: controller.entrar,
                          ),
                        ),

                        const SizedBox(height: 16),

                    const SizedBox(height: 24),

                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.laranja,
                          side: const BorderSide(color: AppColors.laranja),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Get.toNamed(AppRoutes.esqueciSenha);
                        },
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não tem uma conta? '),
                        GestureDetector(
                          onTap: () {
                            // Get.toNamed(AppRoutes.cadastro);
                          },
                          child: const Text(
                            'Crie uma',
                            style: TextStyle(color: AppColors.ciano),
                          ),
                        ),
                      ],
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