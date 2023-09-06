import SwiftUI

struct Fact: Identifiable {
    let value: String
    var id: String { value }
}

struct CounterView: View {
	@State var count: Int = 0
	@State var fact: Fact?

	var body: some View {
		NavigationStack {
			VStack {
				Text("\(count)")
					.font(.largeTitle)

				HStack {
					Button {
						count -= 1
					} label: {
						Image(systemName: "minus")
							.frame(width: 38, height: 28)
					}

					Button {
						count += 1
					} label: {
						Image(systemName: "plus")
							.frame(width: 38, height: 28)
					}
				}
				.buttonStyle(.bordered)

				Button {
					Task { await self.getFact() }
				} label: {
					Text("Get number fact")
				}
				.buttonStyle(.borderedProminent)
			}
			.navigationTitle("Counter")
            .alert(item: $fact) { fact in
                Alert(title: Text(fact.value))
            }
		}
	}

	func getFact() async {
		do {
			let url = URL(string: "http://numbersapi.com/\(count)")!

			let result = try await URLSession.shared.data(from: url)

			self.fact = Fact(value: String(data: result.0, encoding: .utf8)!)
		} catch {
            self.fact = Fact(value: error.localizedDescription)
		}
	}
}

struct CounterView_Previews: PreviewProvider {
	static var previews: some View {
		CounterView(
//			store: .init(
//				initialState: .init(count: 0),
//				reducer: { Counter() }
//			)
		)
	}
}
