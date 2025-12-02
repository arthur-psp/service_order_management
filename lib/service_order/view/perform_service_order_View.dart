import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_order_management/core/injectable.dart';
import 'package:service_order_management/service_order/controller/service_order_controller.dart';
import 'package:service_order_management/service_order/core/domain/model/service_order.dart';
import 'package:service_order_management/service_order/state/servic_order_state.dart';
import 'package:service_order_management/service_order/view/service_order_view.dart';

class PerformServiceOrderView extends StatefulWidget{
  const PerformServiceOrderView({ super.key });

  @override
  State<PerformServiceOrderView> createState() => _PerformServiceOrderViewState();
}

class _PerformServiceOrderViewState extends State<PerformServiceOrderView> {
  late ServiceOrderController controller;
  
  @override
  void initState() {
    super.initState();
    controller = getIt<ServiceOrderController>();
    controller.getServiceOrder();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => controller,
      child: BlocBuilder<ServiceOrderController, ServiceOrderState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFF1E88E5),
              title: const Text(
                'Ordens de Serviço',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => controller.getServiceOrder(),
                ),
              ],
            ),
            body: _buildBody(state, context),
          );
        },
      ),
    );
  }

  Widget _buildBody(ServiceOrderState state, BuildContext context) {
    if (state is ServiceOrderLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
              strokeWidth: 4,
            ),
            const SizedBox(height: 16),
            const Text(
              'Carregando ordens de serviço...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    if (state is ServiceOrderError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Oops! Algo deu errado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => controller.getServiceOrder(),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Tentar Novamente',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (state is ServiceOrderLoaded) {
      if (state.services.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inbox_outlined,
                  color: Color(0xFF1E88E5),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nenhuma ordem de serviço',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crie sua primeira ordem clicando no botão +',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.services.length,
        itemBuilder: (context, index) {
          final service = state.services[index];
          return _buildServiceCard(service, context);
        },
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline, color: Colors.grey, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'Estado desconhecido',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(ServiceOrder service, BuildContext context) {
    final statusColor = _getStatusColor(service.status);
    final statusIcon = _getStatusIcon(service.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _getCardDetails(service, context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name ?? 'Sem nome',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service.description ?? 'Sem descrição',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            service.status ?? 'N/A',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (service.adress != null) ...[
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          service.adress ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(service.createdDate),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getCardDetails(ServiceOrder service, BuildContext context) {
     final nameController = TextEditingController(text: service.name ?? '');
  final descriptionController = TextEditingController(text: service.description ?? '');
  final addressController = TextEditingController(text: service.adress ?? '');
  final statusController = TextEditingController(text: service.status ?? 'pendente');
  
  DateTime? startedDate = service.startedDate;
  DateTime? finalizedDate = service.finalizedDate;
  bool isStarted = startedDate != null;
  bool isFinalized = finalizedDate != null;

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ordem de Serviço',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // ID da ordem
                    Text(
                      'ID: #${service.id?.toString().padLeft(6, '0') ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Toggle Início do Serviço
                    Card(
                      color: const Color(0xFFF5F7FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Início do Serviço',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Marque quando começar',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: isStarted,
                                  activeColor: const Color(0xFF1E88E5),
                                  onChanged: (value) {
                                    setState(() {
                                      isStarted = value;
                                      if (value) {
                                        startedDate = DateTime.now();
                                      } else {
                                        startedDate = null;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            
                            if (isStarted && startedDate != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Color(0xFF1E88E5),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Iniciado em:',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Text(
                                            '${startedDate!.day.toString().padLeft(2, '0')}/${startedDate!.month.toString().padLeft(2, '0')}/${startedDate!.year}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '${startedDate!.hour.toString().padLeft(2, '0')}:${startedDate!.minute.toString().padLeft(2, '0')}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: startedDate!,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );
                                        if (date != null) {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.fromDateTime(startedDate!),
                                          );
                                          if (time != null) {
                                            setState(() {
                                              startedDate = DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                                time.hour,
                                                time.minute,
                                              );
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Toggle Conclusão do Serviço
                    Card(
                      color: const Color(0xFFF5F7FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Conclusão do Serviço',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Marque quando finalizar',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: isFinalized,
                                  activeColor: const Color(0xFF4CAF50),
                                  onChanged: (value) {
                                    setState(() {
                                      isFinalized = value;
                                      if (value) {
                                        finalizedDate = DateTime.now();
                                      } else {
                                        finalizedDate = null;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            
                            if (isFinalized && finalizedDate != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF4CAF50),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Finalizado em:',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Text(
                                            '${finalizedDate!.day.toString().padLeft(2, '0')}/${finalizedDate!.month.toString().padLeft(2, '0')}/${finalizedDate!.year}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '${finalizedDate!.hour.toString().padLeft(2, '0')}:${finalizedDate!.minute.toString().padLeft(2, '0')}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: finalizedDate!,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );
                                        if (date != null) {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.fromDateTime(finalizedDate!),
                                          );
                                          if (time != null) {
                                            setState(() {
                                              finalizedDate = DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                                time.hour,
                                                time.minute,
                                              );
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Campo de Status
                    Card(
                      color: const Color(0xFFF5F7FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status do Serviço',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: statusController.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'pendente',
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text('Pendente'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'em progresso',
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text('Em Progresso'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'concluído',
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text('Concluído'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'cancelado',
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text('Cancelado'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  statusController.text = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Campo de Observações
                    Card(
                      color: const Color(0xFFF5F7FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Observações',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: descriptionController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Descreva os serviços realizados...',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Adicionar Foto (placeholder)
                    Card(
                      color: const Color(0xFFF5F7FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fotos do Serviço',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[400],
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Adicionar fotos',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Botões de Ação
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final updatedOrder = service.copyWith(
                                name: nameController.text,
                                description: descriptionController.text,
                                adress: addressController.text,
                                startedDate: startedDate,
                                finalizedDate: finalizedDate,
                                status: statusController.text,
                                active: true,
                              );
                              
                              //await controller.update(updatedOrder);
                              Navigator.pop(context);
                              controller.getServiceOrder(); // Atualiza a lista
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Salvar Alterações',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pendente':
        return Colors.orange;
      case 'em progresso':
      case 'iniciado':
        return Colors.blue;
      case 'concluído':
      case 'finalizado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pendente':
        return Icons.schedule;
      case 'em progresso':
      case 'iniciado':
        return Icons.autorenew;
      case 'concluído':
      case 'finalizado':
        return Icons.check_circle;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}