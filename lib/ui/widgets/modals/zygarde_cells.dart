part of com.pogo_check_list_ota_labs.app.widgets;

class ZygardeCellsModal extends ConsumerStatefulWidget {
  const ZygardeCellsModal({required this.zygardeCells, super.key});

  final ZygardeCells zygardeCells;

  @override
  ConsumerState<ZygardeCellsModal> createState() => _ZygardeCellsModalState();
}

class _ZygardeCellsModalState extends ConsumerState<ZygardeCellsModal> {
  int _zygardeCellsQuantity = 0;

  @override
  void initState() {
    super.initState();
    _zygardeCellsQuantity = widget.zygardeCells.quantity;
  }

  void addZygardeCells() {
    ++_zygardeCellsQuantity;
    setState(() {});
  }

  void minusZygardeCells() {
    --_zygardeCellsQuantity;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => ModalBase(
    title: 'Células Zygarde',
    centerTitle: true,
    titleStyle: const TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    button: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 8),
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () async {
            ZygardeCells _updateData = ZygardeCells(
              actualForm: widget.zygardeCells.actualForm,
              alternativeForms: widget.zygardeCells.alternativeForms,
              limit: widget.zygardeCells.limit,
              quantity: _zygardeCellsQuantity,
            );
            await ref
                .read(firebasePokemonProvider.notifier)
                .updateZygardeInformation(_updateData, context);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Actualizar ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Image.asset(
                'assets/zygarde_cell.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    ),
    children: <Widget>[
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: addZygardeCells,
                icon: const Icon(Icons.plus_one),
                color: Colors.white,
                splashRadius: 10,
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 8,
                  bottom: 8,
                  right: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/zygarde_cube.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      '$_zygardeCellsQuantity',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: minusZygardeCells,
                icon: const Icon(Icons.exposure_minus_1),
                color: Colors.white,
                splashRadius: 10,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    ],
  );
}
