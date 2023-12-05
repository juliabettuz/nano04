//
//  DidI_Widget.swift
//  DidI-Widget
//
//  Created by Julia Bettuz on 04/10/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    //Quando tá carregando e não tem nada
    func placeholder(in context: Context) -> SimpleEntry {
        @Environment(\.managedObjectContext) var managedObjContext
        
        @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminders: FetchedResults<Reminders>
        
        return SimpleEntry(date: Date(), reminder: loadReminder() ?? ReminderStruct(reminderName: "Não foi possível carregar.", reminderState: false))
    }
    
//Botão
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        @Environment(\.managedObjectContext) var managedObjContext
        
        @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminders: FetchedResults<Reminders>
        let entry = SimpleEntry(date: Date(), reminder: loadReminder() ?? ReminderStruct(reminderName: "Não foi possível carregar.", reminderState: false))
        completion(entry)
    }

    //De tempos em tempos, ele roda isso aqui
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        @Environment(\.managedObjectContext) var managedObjContext
        
        @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var reminders: FetchedResults<Reminders>
        
        var entries: [SimpleEntry] = []
        
        let entry = SimpleEntry(date: Date(), reminder: loadReminder() ?? ReminderStruct(reminderName: "Não foi possível carregar.", reminderState: false))
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .day, value: 1, to: Date())!))
                completion(timeline)
      
    }
    
    func loadReminder () -> ReminderStruct? {
        return ReminderStruct.load()
    }
    
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    var reminder: ReminderStruct
    
}


struct DidI_WidgetEntryView : View {
    var entry: Provider.Entry
//    @Environment(\.managedObjectContext) var managedObjContext
//    
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var test: FetchedResults<Reminders>
//    
    
    
    var body: some View {
        @State var widgetToggle: Bool = entry.reminder.reminderState
        
        ZStack {
            Color("ColorBackground")
            
            VStack {
                
                VStack (alignment: .leading) {
                    
//                    Text("Fiz ou não?")
//                        .font(.system(size: 16))
//                        .fontWeight(.bold)
//                        .padding(.bottom, 16)
                    Spacer()
                    
                    VStack (alignment: .leading) {
                        Text(entry.reminder.reminderName)
                            .font(.system(size: 16))
                            .bold()
                            .padding(.bottom, 1)
                            .padding(.top, 30)
                        
                        Text(widgetToggle ? "Feito ✅" : "Não feito ❌")
                            .font(.system(size: 14))
                    }
                    Spacer()
                    
                }
                
                Button(intent: ToggleIntent(reminderName: entry.reminder.reminderName, reminderToggle: entry.reminder.reminderState ? false : true),label: {
                    Text(widgetToggle ? "Desmarcar" : "Marcar")
                        .font(.system(size: 12))
                        .padding(2)
                      
                       
                })
                .padding(.bottom, 30)
                
            }
            .padding(-30)
        }
    }
}

struct DidI_Widget: Widget {
    let kind: String = "DidI_Widget"
    private var dataController = DataController()

    var body: some WidgetConfiguration {

        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DidI_WidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
//                    .environment (\ .managedObjectContext, dataController.container.viewContext)
            } else {
                DidI_WidgetEntryView(entry: entry)
                    .padding()
                    .background()
//                    .environment (\ .managedObjectContext, dataController.container.viewContext)
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//#Preview(as: .systemSmall) {
//    DidI_Widget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
