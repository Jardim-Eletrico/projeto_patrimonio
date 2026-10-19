
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  void _navegar(BuildContext context, String rota) {
    Navigator.of(context).pop();
    Get.toNamed(rota);
  }

  @override
  Widget build(BuildContext context) {
    const cinzaEscuro = Color(0xFF747474);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logoflutter.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.person_outline,
                color: cinzaEscuro,
              ),
              title: const Text('Perfil'),
              onTap: () => _navegar(context, '/perfil'),
            ),

            ListTile(
              leading: const Icon(
                Icons.school_outlined,
                color: cinzaEscuro,
              ),
              title: const Text('Professores'),
              onTap: () => _navegar(context, '/professores'),
            ),

            ListTile(
              leading: const Icon(
                Icons.manage_accounts_outlined,
                color: cinzaEscuro,
              ),
              title: const Text('Usuários'),
              onTap: () => _navegar(context, '/usuarios'),
            ),

            const Spacer(),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Fechar menu'),
              onTap: () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
