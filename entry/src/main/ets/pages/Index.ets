import { PieCharts, PieChartsData, PieChartsOptions, PieChartsLabelStyle } from '../common/PieCharts'

@Extend(Button)
function setButtonStyle(selected: boolean) {
  .type(ButtonType.Normal)
  .backgroundColor(selected ? Color.Black : '#F5F5F5')
  .fontColor(selected ? Color.White : Color.Black)
  .fontSize(14)
  .padding(0)
  .width(60)
  .height(36)
  .borderRadius(18)
}

class BillModel implements PieChartsData {
  type: number = 0 // 0收入/1支出
  amount: number = 0 // 金额
  category: string = '购物'

  getValue(): number {
    return this.amount
  }
}

@Entry
@Component
struct Index {
  @State billType: number = 0
  @State options: PieChartsOptions = new PieChartsOptions()

  aboutToAppear(): void {
    this.loadData()
  }

  loadData() {
    const expense_categories = ['购物', '出行', '餐饮', '医疗', '美容', '娱乐', '教育', '房租']
    const income_categories = ['工资', '投资', '奖金', '红包', '租金', '礼金', '兼职', '广告']
    const categories = this.billType == 0 ? expense_categories : income_categories
    //mock data
    let data: BillModel[] = []
    for (let i = 0; i < categories.length; i++) {
      let item = new BillModel()
      item.type = this.billType
      item.amount = Math.random() * 100
      item.category = categories[i]
      data.push(item)
    }
    // 根据价格排序
    data = data.sort((a, b) => b.amount - a.amount)

    let options = new PieChartsOptions()
    options.animate = true
    options.duration = 300
    options.data = data
    options.radius = 60
    options.innerRadius = 30
    options.labelFn = (data: PieChartsData) => {
      return (data as BillModel).category
    }
    options.labelStyleFn = (data: PieChartsData, index: number) => {
      let colors = [Color.Green, Color.Blue, Color.Orange, Color.Grey, '#FFCC00', Color.Pink, '#800080', '#ff6633', '#ffcc66', Color.Red]
      let style = new PieChartsLabelStyle()
      style.fontColor = colors[index]
      style.fontSize = 12
      return style
    }
    options.colorFn = (data: PieChartsData, index: number) => {
      let colors = [Color.Green, Color.Blue, Color.Orange, Color.Grey, '#FFCC00', Color.Pink, '#800080', '#ff6633', '#ffcc66', Color.Red]
      return colors[index]
    }
    this.options = options
  }

  build() {
    Navigation() {
      Column() {
        PieCharts({
          options: this.options
        })

        Row() {
          Button('支出')
            .setButtonStyle(this.billType == 0)
            .onClick(() => {
              this.billType = 0
              this.loadData()
            })
          Blank()
            .width(12)
          Button('收入')
            .setButtonStyle(this.billType != 0)
            .onClick(() => {
              this.billType = 1
              this.loadData()
            })
        }
      }
      .size({ width: '100%', height: "50%" })
    }
    .title('收支分析')
    .titleMode(NavigationTitleMode.Mini)
  }
}