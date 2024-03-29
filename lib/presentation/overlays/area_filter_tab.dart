/* FilterChip(
                      selected: filters.filterAreas,
                      selectedColor: Colors.amber,
                      showCheckmark: false,
                      label: const Text("a"),
                      onSelected: (v) => showModalBottomSheet(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                      builder: (context, setStateL) {
                                    return SizedBox.expand(
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            Expanded(
                                              child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    10)),
                                                    color: Colors.green),
                                                child: const Center(
                                                  child: Text(
                                                    "PLACEHOLDER",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              Switch(
                                                  value: filters.filterAreas,
                                                  onChanged: (v) => setStateL(
                                                      () => filters
                                                          .filterAreas = v))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  })).then((value) {
                            // On modalBottomSheet return
                            setState(() {}); // update to show changes!
                          }))
                ], */