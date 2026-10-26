
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/auth_service.dart';
import '../routes/app_routes.dart';

class MenuLateral extends GetView<AuthService> {
  const MenuLateral({super.key});

  void navegar(BuildContext context, String rota) {
    Navigator.of(context).pop();
    Get.toNamed(rota);
  }

  Future<void> sair() async {
  final accessToken = controller.accessToken;

  if (accessToken != null && accessToken.isNotEmpty) {
    await controller.logout(accessToken);
  } else {
    controller.token.value = null;
    controller.usuario.value = null;
  }

  Get.offAllNamed(AppRoutes.login);
}

  @override
  Widget build(BuildContext context) {
    final ehAdmin = controller.ehAdmin;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset(
                  'assets/images/logoflutter.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Opções disponíveis para todos
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Patrimônios'),
              onTap: () => navegar(context, '/patrimonios'),
            ),

            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Meu perfil'),
              onTap: () => navegar(context, '/perfil'),
            ),

            

            // Opções exclusivas do administrador
            if (ehAdmin) ...[
              const Divider(),

              const ListTile(
                title: Text(
                  'PAINEL DE GESTÃO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('Gestão de Professores'),
                onTap: () => navegar(context, '/professores'),
              ),

              ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('Gestão de Usuários'),
                onTap: () => navegar(context, '/usuarios'),
              ),

              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings_outlined,
                ),
                title: const Text('Cadastrar administrador'),
                onTap: () => navegar(
                  context,
                  AppRoutes.cadastrarAdministrador,
                ),
              ),

              ListTile(
              leading: const Icon(Icons.person_add_alt_1),
              title: const Text('Cadastrar professor'),
              onTap: () => navegar(
                context,
                AppRoutes.cadastrarProf,
               ),
              ),
            ],

            const Spacer(),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: sair,
            ),
          ],
        ),
      ),
    );
  }
}
