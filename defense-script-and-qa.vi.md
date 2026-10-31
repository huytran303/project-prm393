# BrewBoss — Kịch bản bảo vệ và bộ câu hỏi nghiệp vụ

Bám theo `SRS_PRM393_G2_Cafe_Shop_Management.docx` (v1.1, 29/10/2026) và `SDS_PRM393_G2_Cafe_Shop_Management.docx` (v1.0, 29/10/2026).

Tài liệu do Claude và Codex rà soát độc lập rồi gộp lại. Các phát hiện và case study của Codex đã được đối chiếu lại với SRS, SDS và trang nguồn trước khi đưa vào.

Tài liệu này thay `presentation-script-diagrams.vi.md`. Bản cũ đã lệch SRS hiện tại: vẫn nói sơ đồ D1–D5 đã bị xoá, đánh số Figure 2-3 → 2-13, gọi Figure 2-1 là flowchart và nói có 10 nguồn tham chiếu (nay là 13).

**Quy ước:** `[ngoặc vuông]` là chỉ dẫn, không đọc. `[C1]`, `[C2]`… là mã case study ở Phần 3. Chỗ ghi "giới hạn v1" nghĩa là tài liệu hiện chưa xử lý, phải nói thẳng, không được nói như đã làm.

---

## Phần 1. Việc cần chốt trước buổi bảo vệ

Các lỗi dưới đây thầy có thể tự phát hiện khi mở tài liệu hoặc bấm link. Nên sửa trước khi vào phòng; nếu không kịp sửa thì nói trước.

| # | Vấn đề | Chỗ trong tài liệu | Cách xử lý |
|---|---|---|---|
| 1 | **Hai link iPOS [12], [13] trả về 404.** Bản `/en/` đã bị gỡ; bản tiếng Việt vẫn mở được. Đây là hai nguồn đỡ cho toàn bộ lập luận "mô hình trả sau". | SRS 5.5 | Đổi thành `https://ipos.vn/san-pham/menu-dien-tu-ipos-o2o/` và `https://ipos.vn/mo-hinh-quan-ca-phe-tra-sua-tra-sau/`. Lưu PDF vào `source-evidence/`, vì hiện chưa có bản lưu của [12], [13]. |
| 2 | **"Decree 123" đã hết hiệu lực.** Nghị định 254/2026/NĐ-CP thay NĐ 123/2020 và NĐ 70/2025 từ 01/07/2026 [C17]. | SRS mục 1, Out of scope | Sửa câu thành "e-invoices under Decree 254/2026/NĐ-CP". |
| 3 | **Ma trận quyền mâu thuẫn.** SRS 3.1.3 ghi Cashier không có quyền với `ingredients, movements` và chỉ `read` với `vouchers`, nhưng thanh toán chạy trên máy thu ngân lại ghi các collection này. SDS 5.1 đã sửa, SRS thì chưa. | SRS 3.1.3 ↔ SDS 5.1 Security Rules | Chép ma trận của SDS sang SRS. |
| 4 | **Sổ kho vừa "append-only" vừa "CRUD".** SDS 5.1.f ghi không cho update/delete, nhưng bảng Security Rules ghi Manager CRUD trên `movements`. Manager cũng CRUD trên `orders`, trái với `paid` là trạng thái kết thúc và với NFR-AUD-01. | SDS 5.1.f ↔ bảng Rules; SRS 3.1.3 | Bỏ update/delete trên `movements` và trên order đã `paid`/`cancelled`, kể cả với Manager. |
| 5 | **Cách tính tiền dự kiến khác nhau.** SRS 3.1.4 #12 và UC44 cộng từ các đơn lúc check-out, ghi "one write". SDS dùng `cashSales`, `qrSales` chạy dồn trên shift và một transaction. SRS 3.1.6 chưa có các trường này. | SRS 3.1.4, 3.1.6, UC44 ↔ SDS 4.1.5, 5.1.b | Cập nhật SRS theo SDS. |
| 6 | **Điểm đổi tối đa không khớp.** UC39 dùng `ceil(...)`, SDS `maxRedeemable` dùng phép chia `÷`, còn BR-LOY-02 cấm làm tổng âm. Với `ceil`, đơn 45.500 ₫ cho đổi 46 điểm, tức khách mất 500 ₫ giá trị điểm. | UC39 ↔ SDS 4.10.1.2 | Chốt một công thức và một cách làm tròn. |
| 7 | **BR-ORD-08 nói "cancellation counts in reports", nhưng S04, S19, UC34, UC36 không có chỉ số huỷ đơn nào.** | SRS 5.1 ↔ 3.9 | Thêm chỉ số huỷ đơn vào S19. Việc này cũng lấp được câu 28. |
| 8 | **Còn tham chiếu nội bộ** `brief §9.3`, `brief §9.4`, `dailyStats` dù changelog nói đã dọn và Product Brief không nộp. | SRS 3.3.3 (IDX), UC35, UC36 | Xoá. |
| 9 | **Form tạo nhân viên không có Trưởng ca.** S05 chỉ có "Quản lý / Thu ngân / Pha chế"; SDS Table 4-5 thì có đủ bốn vai trò. Vai trò thầy yêu cầu thêm lại không tạo được trên màn hình SRS. | SRS UC04 ↔ SDS `roleRadioGroup` | Thêm "Trưởng ca". |
| 10 | **Thêm món làm mất kiểm soát huỷ.** Đơn `served` thêm món quay về `pending`, mà thu ngân được sửa dòng và huỷ đơn `pending`, kể cả phần khách đã uống. Mock-up S14g có khoá lượt cũ, nhưng UC21 và BR-ORD-05 thì không. | UC21, BR-ORD-04, BR-ORD-05, BR-INV-02 | Khoá theo lượt: lượt đã bắt đầu pha thì chỉ trưởng ca được huỷ. |
| 11 | **Từ chối món gọi thêm có thể làm trống bàn đang có bill.** UC27 luôn xoá `currentOrderId`, kể cả với đơn QR `awaiting` không giữ bàn. | UC27, 3.1.4 #7, BR-ORD-07 | Chỉ xoá khi `currentOrderId` trỏ đúng đơn bị huỷ. |
| 12 | **Trưởng ca không qua được UC30.** Ma trận cho trưởng ca pha chế, nhưng precondition chỉ ghi `barista or manager`. | SRS 3.1.3 ↔ UC30 | Thêm supervisor. |
| 13 | **UC21 tự mâu thuẫn.** Precondition cho `ready` thêm món, exception số 2 lại coi `ready` là read-only. | UC21 | Sửa exception. |
| 14 | **Undo không có trong state machine.** UC30 AT4 đưa `ready` về `preparing` nhưng STATE và bảng chuyển trạng thái không có cạnh này, cũng chưa nói nếu đơn đã `served` thì sao. | UC30, STATE, 2.1.2 | Thêm cạnh có điều kiện. |
| 15 | **S17 mô tả sai.** Ghi "shows the rejection when the table has an open order", trong khi OI-07 và UC32 đã cho gọi thêm. | SRS 3.1.2 | Sửa mô tả. |
| 16 | **Kiểm kho không thống nhất.** SRS 4.2.2 nói rollback cả khối, còn UC42 và SDS chạy transaction riêng từng nguyên liệu. | SRS 4.2.2 ↔ UC42, SDS 4.5 | Chọn một cách và ghi rõ. |
| 17 | **Schema QR khác nhau.** SRS 3.1.6 ghi `createdBy` là "anonymous" và `shortId` bắt buộc; SDS và UC32 dùng anonymous uid, `shortId` rỗng khi `awaiting`. | SRS 3.1.6 ↔ SDS 5.1.h | Cập nhật SRS. |
| 18 | **Món bán chạy thiếu doanh thu.** UC36 yêu cầu kèm doanh thu, `topProducts` chỉ trả về số lượng; cũng chưa có rule phân bổ voucher và điểm xuống từng món. | UC36 ↔ SDS 4.9.1.2 | Sửa kiểu trả về và ghi rõ là doanh thu trước giảm giá. |
| 19 | **Bản PDF minh chứng có thể không có câu trích.** Tìm chữ trong PDF [2], [4] không thấy các câu trích (có thể do PDF dạng ảnh hoặc tab đang đóng). | `source-evidence/` | Khi thầy hỏi, mở ảnh `E-[n]-*.png`. Kiểm tra PDF bằng mắt trước buổi. |

**Bốn thay đổi nghiệp vụ đáng làm nhất**, vì tốn ít mà chặn được câu hỏi khó nhất:

1. **Blind count:** đổi thứ tự UC44, cho nhập tiền đếm trước, rồi mới hiện tiền dự kiến (câu 21).
2. **Một ngăn kéo tiền, một người giữ tại một thời điểm:** thêm rule vào BR-STAFF (câu 22).
3. **Đối soát cuối ngày:** Manager so `qrSales` với sao kê ngân hàng; thêm bước này vào 2.1.3 (câu 24).
4. **Khoá theo lượt:** lượt đã bắt đầu pha thì thu ngân không được sửa hay huỷ (câu 51).

Làm xong thì sửa lại các câu tương ứng, bỏ chữ "giới hạn v1".

---

## Phần 2. Kịch bản thuyết trình

**Thời lượng:** 15 phút. **Phân công** theo SRS A5: Huy (AUTH, STAFF), Nghĩa (POS), Cường (BAR, CUS, RPT, LOY), Quang Anh (MENU, INV).

| Phần | Người nói | Hình | Đủ | Bản 8 phút |
|---|---|---|---|---|
| 0. Mở đầu, nguồn tham khảo và luận điểm | Huy | Bìa SRS | 1'30" | 1' |
| 1. Bài toán và mô hình tham chiếu | Huy | SRS 1-1, 1-2, 1-3 | 2'30" | 1'30" |
| 2. Một ca bán hàng | Nghĩa | SRS 2-1, 2-2 | 3' | 2' |
| 3. QR và pha chế | Cường | SRS 2-6; SDS 3-3 | 2' | 1' |
| 4. Tiền và kiểm soát ca | Huy | SRS UC44, 3.1.3 | 2' | 1' |
| 5. Kho và công thức | Quang Anh | SRS 3-2; SDS SD-08 | 2' | 1' |
| 6. Khách hàng thân thiết và báo cáo | Cường | S15, S19 | 1' | bỏ |
| 7. Thiết kế đỡ nghiệp vụ, giới hạn, kết luận | Huy | SDS 2-1, 5-1 | 1' | 30" |

### 0. Mở đầu — Huy

[Bìa SRS]

"Thưa thầy, nhóm 2 trình bày BrewBoss, hệ thống quản lý quán cà phê một chi nhánh trên Flutter và Firebase.

Trước hết, em nói rõ nhóm tham khảo ai. Về mô hình quán: cơ cấu vai trò tham chiếu mô hình cửa hàng của Starbucks, đối chiếu thêm với tin tuyển dụng của Highlands. Cách phục vụ thì theo mô hình quán ngồi tại bàn, trả tiền sau mà iPOS mô tả, vì Starbucks phục vụ tại quầy và thu tiền trước. [C1, C10, C13]

Về ứng dụng: phần tích điểm học từ Starbucks Rewards, chương trình mà trong quý 4 năm tài chính 2025, chi tiêu của thành viên chiếm 58% giá trị thanh toán tại các cửa hàng Starbucks trực tiếp vận hành ở Mỹ; nhưng BrewBoss tích điểm theo số điện thoại, không bắt khách cài app. Phần gọi món bằng QR học từ Sapo QR Order, nơi đơn được xử lý sau khi nhân viên xác nhận. Case có số liệu rõ nhất về QR tại bàn là Centro Restaurant Group ở Mỹ: theo Olo, nhà cung cấp của họ, công suất giờ cao điểm tăng hơn 20%, sai đơn giảm từ 15–20 xuống còn 1–2 đơn mỗi ngày. [C2, C11, C24] Các số này do chính doanh nghiệp công bố. Chúng cho thấy cơ chế đang chạy thật, chưa chứng minh BrewBoss sẽ đạt cùng kết quả.

Nhóm không đi theo từng màn hình, mà theo từng quyết định nghiệp vụ. Với mỗi quyết định, nhóm nói ba điều: doanh nghiệp thật nào đã làm, nhóm lấy gì từ họ, và chỗ nào nhóm không theo họ. Những chỗ tài liệu chưa giải quyết, nhóm cũng sẽ nói thẳng."

### 1. Bài toán và mô hình tham chiếu — Huy

[SRS mục 1, bảng mục tiêu]

"Quán nhỏ và vừa ở Việt Nam đang có bốn vấn đề: mất hoặc sai đơn lúc đông, không biết món nào bán chạy và nguyên liệu nào sắp hết, thất thoát do bán không ghi nhận và giảm giá không kiểm soát, và mất công chấm công, đếm tiền. BrewBoss đặt bốn mục tiêu G1 đến G4 để xử lý các vấn đề này. Các con số trong bảng là mục tiêu demo, chưa phải số đo tại quán thật."

[SRS Figure 1-2]

"Về tổ chức, nhóm tham chiếu mô hình cửa hàng của Starbucks. Starbucks không công bố sơ đồ tổ chức, nên hình này được nhóm suy ra từ mô tả vị trí trên các trang chính thức của họ tại Mỹ, Úc, Indonesia và Đức. Bảng ngay dưới hình trích nguyên văn câu làm căn cứ cho từng đường báo cáo. Ví dụ, trang Úc ghi trưởng ca 'assisting the store manager in executing store operations during shifts' và được đào tạo 'cash controller responsibilities'."

[SRS Figure 1-3 và bảng ánh xạ]

"Từ đó nhóm rút thành bốn vai trò. Store Manager và Assistant gộp thành Owner/Manager vì quán một chi nhánh chỉ có một người quản lý. District Manager nằm ngoài phạm vi. Shift Supervisor giữ nguyên, vì đó là lớp kiểm soát ở cấp ca. Barista của Starbucks được phân vào quầy hoặc bar, còn nhóm tách thành Cashier và Barista vì hai vị trí dùng hai thiết bị và hai màn hình khác nhau."

"Có một điểm nhóm cố ý **không** theo Starbucks. Starbucks phục vụ tại quầy, khách trả tiền trước. BrewBoss nhắm tới quán ngồi lại, phục vụ tại bàn, trả tiền sau. Đây là mô hình mà iPOS tách riêng thành 'quán cà phê, trà sữa trả sau', với các nghiệp vụ gọi thêm món, chuyển bàn, gộp bàn. Vì vậy, nhóm học Starbucks về vai trò, và học các nhà cung cấp POS Việt Nam như Sapo, iPOS về luồng bán hàng."

[SRS Figure 1-1]

"Sơ đồ ngữ cảnh chốt ranh giới: Firebase nằm trong hệ thống. VietQR chỉ trả ảnh mã QR, không có chiều báo tiền đã về. Điểm này ảnh hưởng đến kiểm soát tiền mà lát nữa nhóm sẽ nói."

### 2. Một ca bán hàng — Nghĩa

[SRS Figure 2-1]

"Hình này là một ngày vận hành, có làn riêng cho từng vai trò và một làn cho hệ thống. Em đi vào giai đoạn phục vụ.

Thu ngân tạo đơn thì đơn ở `pending` và lên hàng đợi pha chế ngay. Pha chế bấm Bắt đầu, rồi Xong. Hệ thống báo quầy, thu ngân giao món và đánh dấu `served`. Chỉ từ `served` mới thanh toán được, theo BR-PAY-04."

[SRS Figure 2-2]

"Máy trạng thái có hai trạng thái kết thúc là `paid` và `cancelled`. Có ba quy tắc đáng chú ý.

Thứ nhất, gọi thêm món. Trong mô hình trả sau, khách gọi thêm là chuyện thường xuyên. Nếu đơn còn `pending` hoặc `preparing`, món mới vào cùng lượt. Nếu đã `ready` hoặc `served`, món mới thành lượt mới, đơn quay về `pending`, và pha chế chỉ thấy lượt mới, theo BR-ORD-04.

Thứ hai, huỷ đơn. Thu ngân chỉ huỷ được đơn `awaiting` hoặc `pending`. Từ lúc pha chế bắt đầu, chỉ trưởng ca hoặc quản lý mới huỷ được và phải ghi lý do, theo BR-ORD-05. Đây chính là vai trò kiểm soát ca lấy từ Starbucks.

Thứ ba, thanh toán. Một transaction duy nhất đóng đơn, trừ kho theo công thức, cộng điểm, tăng lượt dùng voucher và trả bàn, theo NFR-REL-01. Nhờ vậy doanh thu, kho và điểm không thể lệch nhau vì lỗi giữa chừng."

### 3. QR và pha chế — Cường

[SRS Figure 2-6, màn S17 và S14c]

"Khách quét QR tại bàn, xem menu và đặt món mà không cần cài app, vì SDS chốt bản web Flutter trên Firebase Hosting. Đơn tạo ra ở trạng thái `awaiting`, chưa tới pha chế và chưa chiếm bàn. Thu ngân kiểm tra lại giá rồi xác nhận, theo BR-ORD-07.

Có hai cách làm trên thị trường. Theo tài liệu của Sapo, đơn được chuyển sang chế biến sau khi nhân viên xác nhận. Trang iPOS O2O thì mô tả đơn được đẩy trực tiếp đến khu vực chế biến. Nhóm chọn cách của Sapo vì BrewBoss dùng ID bàn tĩnh, không kiểm tra vị trí, nên đơn từ xa phải có người chặn. Cái giá là thu ngân có thêm một thao tác lúc đông.

Case có số liệu cụ thể nhất nhóm tìm được là Centro Restaurant Group ở Mỹ: theo Olo, nhà cung cấp của họ, sau khi cho gọi món bằng QR tại bàn, công suất giờ cao điểm tăng hơn 20%, sai đơn giảm từ 15–20 xuống còn 1–2 đơn mỗi ngày, nhân viên chuyển sang đón khách, mang món và dọn bàn. Số này do nhà cung cấp công bố, và trang không nói Centro có bước xác nhận như BrewBoss, nên nhóm chỉ dùng làm tham chiếu.

Về hàng đợi, pha chế thấy đơn cũ nhất trước, nhận đơn qua listener thời gian thực, mục tiêu dưới 2 giây. Starbucks trong năm 2025 chuyển sang thuật toán Smart Queue vì họ có nhiều kênh chạy song song. Quán một chi nhánh, đơn tại quầy và đơn QR cùng đi qua thu ngân, nên v1 giữ thứ tự đến trước làm trước. Bài học nhóm lấy từ Starbucks là: thêm kênh gọi món mà không kiểm soát dòng đơn thì có thể làm dịch vụ chậm đi."

### 4. Tiền và kiểm soát ca — Huy

[SRS 2.1.3, UC44]

"Mục tiêu của UC44 là truy được khoản lệch về một ca và một người. Mỗi người giữ tiền mở ca với tiền đầu ca. Mỗi thanh toán thuộc ca của người xác nhận. Tiền dự kiến bằng tiền đầu ca cộng tiền mặt người đó đã thu; VietQR không tính vào ngăn kéo. Lệch khác không thì bắt buộc ghi chú, và sau khi check-out các trường tiền bị khoá.

Về VietQR, QR trên màn hình là QR động theo đúng số tiền và mã đơn, không phải QR in sẵn dán trên quầy. Báo chí Việt Nam đã cảnh báo hai kiểu gian lận: bill chuyển khoản giả và dán đè mã QR tĩnh. Vì v1 chưa có webhook ngân hàng, thu ngân phải kiểm tra tài khoản rồi mới bấm 'Đã nhận tiền'.

Nhóm nói rõ giới hạn: xác nhận thủ công có rủi ro nội bộ, nên cần đối soát với sao kê. Bước tự động hoá tiếp theo là dịch vụ báo biến động số dư; VietQR API hiện nêu hỗ trợ liên kết với MB và BIDV."

### 5. Kho và công thức — Quang Anh

[SRS Figure 3-2, UC14, UC15, UC42]

"Mỗi size của mỗi món có một công thức. Khi thanh toán, hệ thống trừ nguyên liệu trong cùng transaction, ghi dòng `sale` vào sổ kho. Nhóm trừ lúc thanh toán chứ không phải lúc tạo đơn, vì đơn mở còn sửa và huỷ được. Đồ đã pha mà huỷ thì trừ riêng dưới dạng hao hụt, theo BR-INV-02.

Tồn trên hệ thống chỉ là tồn lý thuyết, nên phải có kiểm kho. Toast định nghĩa mức dùng thực tế bằng tồn đầu cộng nhập trừ tồn cuối, và chênh lệch bằng thực tế trừ lý thuyết. BrewBoss đi theo tư duy đó: kiểm kho ghi lại số đếm trừ tồn hệ thống làm dòng điều chỉnh. Tin tuyển dụng của Highlands cũng yêu cầu học viên quản lý cửa hàng được đào tạo kiểm kê hằng ngày, giữa tháng và cuối tháng. Café Crêpe là ví dụ về giá trị của việc nối dữ liệu pha chế và hao hụt: theo TouchBistro và MarketMan, thời gian tìm nguyên nhân lệch kho giảm từ 7–8 giờ mỗi tuần xuống còn 5–60 phút. BrewBoss mới làm được một phần, vì kiểm kho cho biết lệch bao nhiêu chứ chưa cho biết vì sao.

Vì sao chưa dùng công nghệ đếm tự động? Starbucks triển khai đếm kho bằng AI cho hơn mười nghìn cửa hàng năm 2025, nhưng báo chí đưa tin họ đã ngừng dùng vào tháng 5/2026 để chuẩn hoá lại cách đếm. Nên nhóm giữ kiểm kho thủ công là có cơ sở.

Giới hạn v1: topping chưa có công thức, theo BR-INV-04. Phần này được chỉnh qua kiểm kho, và lộ trình nâng cấp đã ghi trong rule."

### 6. Khách hàng thân thiết và báo cáo — Cường

[S15, S19]

"Starbucks cho thấy giá trị của chương trình thành viên: thành viên chiếm gần 60% doanh thu cửa hàng trực tiếp vận hành tại Mỹ trong năm tài chính 2025. BrewBoss làm bản tối giản, tích điểm theo số điện thoại, không bắt khách cài app. Tỉ lệ tích và đổi điểm là tham số quản lý chỉnh được. Về báo cáo, doanh thu chỉ tính đơn `paid`, theo BR-RPT-01; S19 có biểu đồ doanh thu, món bán chạy và doanh thu theo phương thức."

### 7. Thiết kế đỡ nghiệp vụ, giới hạn và kết luận — Huy

[SDS Figure 2-1 và 5-1]

"SDS chuyển các quy tắc này thành thiết kế. Không có server riêng, nên toàn vẹn dữ liệu dựa vào transaction và Security Rules. Ví dụ: thu ngân chỉ ghi được kho, điểm và tiền của ca khi cùng commit đó chuyển đơn sang `paid` hoặc `cancelled`.

Nhóm nói rõ những gì v1 chưa làm: chưa có hoá đơn điện tử, chưa tách hoá đơn theo người, chưa có hoàn tiền sau thanh toán, chưa bán được khi mất mạng hoàn toàn, chưa có báo cáo lợi nhuận gộp. Các phần này đều có case study và hướng nâng cấp, nhóm sẵn sàng trao đổi.

Tóm lại: vai trò học từ Starbucks, luồng bán học từ POS Việt Nam, kiểm soát tiền và kho theo thực hành ngành. Case study cho thấy các cơ chế này đang được dùng thật, nhưng chưa chứng minh được BrewBoss sẽ đạt cùng kết quả. Việc đó cần đo ở một quán thật. Nhóm em xin hết."

---

## Phần 3. Kho case study

**Độ tin cậy:** **A** là tài liệu của chính công ty hoặc cơ quan quản lý. **B** là báo chí hoặc bài tổng hợp. **C** là nhà cung cấp tự công bố, chỉ đủ chứng minh tính năng tồn tại, không đủ chứng minh hiệu quả.

| Mã | Doanh nghiệp | Sự kiện đã kiểm chứng | Đỡ cho quyết định | Lưu ý khi dùng | Mức |
|---|---|---|---|---|---|
| C1 | Starbucks — vai trò | Năm vị trí cửa hàng; trưởng ca điều hành ca, có đào tạo kiểm soát tiền | 4 vai trò, UC27, UC45 | Sơ đồ là **suy ra**, Starbucks không công bố | A (SRS [1]–[4]) |
| C2 | Starbucks Rewards | Q4 FY25: chi tiêu của thành viên chiếm 58% giá trị thanh toán tại cửa hàng do công ty vận hành ở Mỹ; gần 60% doanh thu, hơn 13 tỉ USD | UC38–UC41 | Họ có app và thẻ trả trước; BrewBoss chỉ có số điện thoại | A |
| C3 | Starbucks — thể lệ 2026 | Hạng Green tích 1 sao/USD; sao Green hết hạn sau 6 tháng nếu không có hoạt động; có nguồn ghi 60 sao đổi 2 USD | Phản biện mức 10% của BrewBoss | Tỉ lệ khoảng 3,3% là **nhóm tự tính**, chỉ áp dụng cho hạng Green tại Mỹ, chưa tính ưu đãi | B |
| C4 | Starbucks — mobile order | 31% giao dịch tại Mỹ trong FY25, 33% ở Q3 FY26. Năm 2017 có khoảng 1.200 cửa hàng đông nhất đạt trên 20% giao dịch giờ cao điểm qua mobile và bị nghẽn. Q2 FY24 có tỉ lệ đơn bỏ dở mức "mid-teens" trong kênh này | Cổng xác nhận QR, kiểm soát dòng đơn | Số bỏ dở là của kênh mobile, không phải QR tại bàn | A/B |
| C5 | Starbucks — Smart Queue | Mục tiêu 4 phút tại quầy, 12 phút với mobile/giao hàng. Công ty nói hơn 80% cửa hàng đạt mức trung bình 4 phút | Hàng đợi, `lateOrderMinutes` | Số do công ty nói trong họp kết quả kinh doanh, chưa có kiểm toán độc lập. Có phân tích cho rằng sắp xếp thôi chưa đủ, còn cần nhân lực | B |
| C6 | Starbucks — sự cố POS 24/04/2015 | POS ngừng tại Mỹ và Canada trong đợt cập nhật menu hằng ngày; nhiều cửa hàng đóng sớm, có nơi phát đồ uống miễn phí | Rủi ro phụ thuộc hệ thống | Số cửa hàng ảnh hưởng khác nhau giữa các nguồn | B |
| C7 | Starbucks × NomadGo | Triển khai đếm kho AI tại hơn 11.000 cửa hàng năm 2025; ngừng dùng tháng 5/2026. Starbucks nói để "standardize how inventory is counted". Nhân viên báo đếm trùng do phản chiếu, mất phiên đếm khi rớt Wi-Fi | Giữ kiểm kho thủ công (UC42) | Lỗi cụ thể đến từ lời kể nhân viên qua báo chí, Starbucks không nêu các lỗi đó làm lý do | B |
| C8 | Highlands Coffee | Hơn 900 cửa hàng; doanh thu 2024 khoảng 4.600 tỉ, EBITDA trên 1.000 tỉ; mô hình drive-thru khoảng 3 phút; tự order tại quầy và tự lấy đồ từ 2013 | So sánh mô hình; mốc tốc độ | 3 phút là thiết kế của drive-thru, không phải cam kết toàn chuỗi | B |
| C9 | Highlands × NAPAS | Công bố 16/06/2025 triển khai VietQRPay toàn quốc; có tích điểm thành viên tại quầy | VietQR, tích điểm tại quầy | Mới thấy qua kết quả tìm kiếm, chưa mở được toàn văn | B |
| C10 | Highlands — tuyển dụng | Đào tạo quy trình tiền mặt, theo dõi nhân viên từng ca, kiểm kê hằng ngày/giữa tháng/cuối tháng | UC42, UC44 | Là tin tuyển dụng, không phải quy trình nội bộ | A (SRS [5], [6]) |
| C11 | Sapo QR Order | Khách quét QR gọi món, gọi nhân viên, yêu cầu thanh toán; đơn được xử lý sau khi nhân viên xác nhận; có giới hạn gửi yêu cầu liên tiếp | BR-ORD-07 | Tiêu đề Bước 7 ghi "tự động chuyển về thu ngân và bếp"; câu "sau khi xác nhận" nằm trong phần thân | C (SRS [11]) |
| C12 | iPOS O2O | Đơn "được đẩy trực tiếp đến từng khu vực chế biến" | **Phản ví dụ** của cổng xác nhận | Dùng để cho thấy nhóm đã cân nhắc hai cách | C |
| C13 | iPOS — trả sau, trả trước | Tách hai mô hình. Trả sau: "Gộp bàn - tách hóa đơn - thêm món", thanh toán tại quầy hoặc tại bàn, trừ nguyên liệu "đến từng gram topping", chấm công FaceID/Wi-Fi, hoá đơn nối cơ quan thuế. Trả trước: QR đúng số tiền, có âm thanh báo khi thanh toán thành công | BR-PAY-04, UC26 | **Lộ ra khoảng trống** của BrewBoss: tách hoá đơn, topping, chấm công, hoá đơn | C |
| C14 | iPOS — phần mềm order | Order chuyển tới bếp/bar, "thông báo cho nhân viên phục vụ", rồi chuyển thu ngân in hoá đơn | Luồng trả sau | Có vai trò phục vụ riêng, BrewBoss thì không | C |
| C15 | VietQR API; Sapo VietQR PRO | Báo biến động số dư qua webhook/WebSocket, đối soát theo mã QR; trang nêu liên kết MB, BIDV. Sapo có cập nhật trạng thái thanh toán | Lộ trình cho A4 | Chỉ một số ngân hàng; chưa kiểm chứng được KiotViet | C |
| C16 | Bill giả, QR dán đè | Bill giả tạo được bằng website; chủ quán bận không kiểm tra nên mất tiền; dán đè QR tại cửa hàng | QR động, kiểm tra trước khi xác nhận | Cảnh báo chung, không có số thống kê | B |
| C17 | Pháp lý hoá đơn | NĐ 254/2026 thay NĐ 123/2020 và NĐ 70/2025 từ 01/07/2026. Nguồn thứ cấp ghi hộ kinh doanh doanh thu trên 1 tỉ/năm phải dùng hoá đơn có mã hoặc từ máy tính tiền | Out of scope | **Các nguồn thứ cấp chưa thống nhất** về bán lẻ trực tiếp. Phải đọc văn bản gốc trước khi nói con số | B |
| C18 | Pháp lý dữ liệu | Luật 91/2025/QH15 và NĐ 356/2025 hiệu lực từ 01/01/2026; số điện thoại nằm trong danh mục dữ liệu; đồng ý phải xác định được nội dung và thời điểm | UC38 | Chưa đọc văn bản gốc phần áp dụng cho chương trình thành viên | B |
| C19 | Luckin Coffee | COO làm giả khoảng 2,2 tỉ NDT doanh số 2019; phạt SEC 180 triệu USD; sau đó phục hồi với mô hình chỉ đặt qua app | Vì sao sổ sách phải bất biến | Là gian lận cấp tập đoàn, chỉ dùng để nói nguyên tắc | A/B |
| C20 | Toast, Square — offline | Toast tự vào offline sau 40 giây mất mạng, vẫn order được, KDS nhận đơn qua hub cục bộ; Square nhận thẻ offline, xử lý khi có mạng; đều có rủi ro thẻ bị từ chối | Phản biện NFR-REL-02 | Tài liệu nhà cung cấp, thị trường Mỹ | C |
| C21 | Toast xtraCHEF | Thực tế = tồn đầu + nhập − tồn cuối; chênh lệch = thực tế − lý thuyết; thực tế luôn cao hơn lý thuyết | UC15, UC42, BR-INV-03 | Định nghĩa, không phải kết quả đo | C |
| C22 | Blind count | RMH có chức năng blind closeout; hướng dẫn POS khuyến nghị đếm trước khi thấy số hệ thống, cân ngăn kéo mỗi ca khi nhiều ca, người đếm và người xác minh là hai người | UC44 | Chỉ là khuyến nghị từ phần mềm/hướng dẫn | C |
| C23 | QR tại bàn — hiệu quả | Sunday báo check tăng 12%, DoorDash/Curry Up Now báo 15%; khảo sát Union 2023 có gần 44% người hỏi muốn tự đặt trên điện thoại | Lợi ích của UC32 | **Toàn số nhà cung cấp.** Nhóm không tìm thấy nghiên cứu độc lập; không dùng làm bằng chứng chính | C |
| C24 | Centro Restaurant Group (Olo) | 98% giao dịch là digital; công suất giờ cao điểm tăng hơn 20%; sai đơn từ 15–20 xuống 1–2 mỗi ngày; nhân viên chuyển sang đón khách, mang món, dọn bàn; có phí dịch vụ 10% cho đơn QR | UC32, câu 4 | **Case có tên và số tốt nhất cho QR**, nhưng Olo tự công bố. Trang không nói có bước xác nhận | C |
| C25 | Café Crêpe (TouchBistro + MarketMan) | Chuyển khỏi sổ giấy; tìm nguyên nhân lệch kho giảm từ 7–8 giờ/tuần xuống 5–60 phút | UC14, UC42, BR-INV-03 | Nhà cung cấp công bố. **Phản biện** ý "chỉ cần kiểm kho là đủ" | C |
| C26 | Offset Coffee (Square) | Một sự cố kéo dài hai ngày, quán dùng thanh toán offline, chủ quán nói khách không bị ảnh hưởng; thanh toán không đồng bộ trong 24 giờ sẽ bị từ chối | Câu 47 | Mức tăng 40%/năm là lời chủ quán, không dùng được làm bằng chứng cho Square | C |
| C27 | Square — tài liệu nghiệp vụ | Phiên ngăn kéo theo dõi tiền đầu, tiền bán, hoàn tiền, paid in/out, tiền dự kiến. Phân biệt tách bill (theo món, ghế) với tách thanh toán (theo số tiền). Đổi thưởng tại quầy chỉ cần tên hoặc số điện thoại | UC44, UC46, UC39 | Tính năng, không phải kết quả. **Đỡ một phần** cho việc không dùng OTP | C |
| C28 | Starbucks Mobile Order & Pay (2015) | Khách trả tiền lúc đặt, rồi mới đến nhận | **Phản ví dụ** của BR-PAY-04 | Là order-ahead, không dùng được để chứng minh QR tại bàn | A |
| C29 | The Coffee House (iPOS, 2022) | Dùng POS cảm ứng, theo dõi từ xa, tích hợp ví, voucher, điểm, API riêng; thời gian mua 10–15 phút xuống 2–3 phút với Pick Up là ước tính của bài viết | Giá trị POS tích hợp | **Không dùng làm "case thành công":** bài do iPOS viết, và chuỗi đã thu hẹp từ 93 xuống 78 cửa hàng cuối 2025 theo báo chí. Không suy ra nguyên nhân từ việc này | C |
| C30 | Grupo Las Palomas (Glory) | Chọn máy tái chế tiền mặt để giảm thời gian đối soát và loại bỏ chênh lệch | UC44 | Trang chỉ nêu **mục tiêu**, không có kết quả đo | C |

---

## Phần 4. Câu hỏi và trả lời

**Mẫu trả lời:** quyết định → cơ sở trong tài liệu → case study → giới hạn. Mỗi câu không quá 30 giây. **Đừng bịa số:** nếu bị hỏi một con số không có trong Phần 3, trả lời "dạ, nhóm chưa có số kiểm chứng, nhóm sẽ gửi lại nguồn sau".

### A. Mô hình kinh doanh và cách dùng case study

**1. Em theo Starbucks, nhưng Starbucks thu tiền trước, em lại thu sau. Vậy case study của em có còn dùng được không?**
"Dạ, nhóm chỉ lấy của Starbucks phần vai trò cấp cửa hàng, không lấy kênh gọi món; SRS mục 1 ghi rõ câu đó. Luồng trả sau tham chiếu iPOS và Sapo [C11, C13]."
*Hỏi tiếp: "Vậy sao không chọn một quán trả sau làm chuẩn?"* → "Dạ, nhóm chưa tìm được chuỗi trả sau nào công bố mô tả vai trò đầy đủ như Starbucks. Đây là hạn chế về nguồn."

**2. Case study 'thành công' ở chỗ nào? Starbucks lớn đâu có nghĩa cơ cấu đó làm họ thành công?**
"Dạ đúng, nhóm không khẳng định quan hệ nhân quả. Case study chỉ chứng minh cơ chế đó đang vận hành thật ở quy mô lớn, nên là mô hình tham chiếu hợp lý. Hiệu quả của BrewBoss phải đo ở quán thật."
*Hỏi tiếp: "Đo bằng gì?"* → "Dạ, đo trước và sau: thời gian từ tạo đơn tới giao món, số đơn sai, chênh lệch tiền mỗi ca, chênh lệch kho. Hiện G1–G4 mới là mục tiêu demo."

**3. Vì sao không tham chiếu Highlands, doanh nghiệp Việt Nam?**
"Dạ có dùng Highlands [5], [6] cho nhiệm vụ quản lý, tiền mặt, kiểm kê. Nhưng Highlands không công bố đầy đủ các cấp như Starbucks, và tự order tại quầy từ 2013 [C8], cũng không phải mô hình trả sau."

**4. Mô hình phục vụ tại bàn mà không có nhân viên phục vụ à? Thu ngân rời quầy bưng nước thì ai giữ tiền?**
"Dạ, đây là giới hạn của v1. iPOS mô tả luồng có nhân viên phục vụ được báo để mang món ra [C14], còn BrewBoss gộp vào Cashier để giữ bốn vai trò. Quán nhiều nhân viên có thể cấp tài khoản Cashier cho người phục vụ, nhưng khi đó họ thừa quyền thu tiền. Ở Centro, dù có QR, nhân viên vẫn mang món ra bàn [C24]. Hướng đúng là thêm vai trò Server chỉ có tạo đơn và đánh dấu đã phục vụ."

**5. Quán 'nhỏ và vừa' của em là bao nhiêu bàn, bao nhiêu nhân viên?**
"Dạ, SRS chưa định lượng. Nhóm giả định quán một chi nhánh, có cả thu ngân và pha chế riêng trong ca. Nhóm cần bổ sung chân dung quán mục tiêu cụ thể vào mục 1."

**6. Quán một mình chủ vừa pha vừa thu thì có cần trưởng ca không?**
"Dạ không. Manager có mọi quyền. Quyền là theo tài khoản, không bắt buộc quán phải tuyển đủ bốn người. Quán không có trưởng ca thì việc huỷ đơn đã pha đi qua Manager."
*Hỏi tiếp: "Chủ không có ở quán thì sao?"* → "Dạ, Manager thao tác được trên điện thoại từ xa, nhưng phải có mạng."

**7. Quán đã có Sapo, iPOS, sao phải dùng BrewBoss?**
"Dạ, đây là đồ án môn học, chưa phải sản phẩm thương mại; canvas ở Figure 1-4 mô tả mô hình của quán, không phải của BrewBoss. Nếu thương mại hoá, BrewBoss hiện còn thiếu nhiều so với iPOS [C13]: hoá đơn, tách bill, offline. Nhóm không nên nói là tốt hơn họ."

**8. Mục tiêu dưới 2 giây là kỹ thuật. Khách có quan tâm không? Chỉ số nghiệp vụ đâu?**
"Dạ, đúng là G1 đo hệ thống. Khách quan tâm thời gian nhận món. Starbucks đặt mốc 4 phút [C5]; drive-thru Highlands thiết kế khoảng 3 phút [C8]. BrewBoss có `lateOrderMinutes` mặc định 10 phút, chỉ là ngưỡng cảnh báo, nhóm chưa có dữ liệu để chứng minh 10 là đúng, nên để quản lý chỉnh."

### B. Đơn hàng, QR và phục vụ

**9. Vì sao đơn QR phải qua thu ngân xác nhận?**
"Dạ, vì ba lý do trong BR-ORD-07 và UC22: QR bàn là ID tĩnh, không kiểm tra vị trí nên có thể đặt từ xa; giá phải kiểm lại; và tránh đơn rác vào hàng đợi. Sapo cũng xử lý đơn sau khi nhân viên xác nhận [C11]."
*Hỏi tiếp: "Sao iPOS đẩy thẳng được?"* → "Dạ, trang iPOS O2O mô tả đơn đẩy trực tiếp [C12]. Nhóm chọn cách an toàn cho v1. Có thể làm cấu hình theo quán sau."

**10. QR để giảm tải cho nhân viên, em bắt thu ngân bấm xác nhận thì lúc đông có nghẽn không?**
"Dạ có thể nghẽn, đó là đánh đổi. Bù lại, thu ngân không phải đi ghi món và nhập lại. Bài học của Starbucks là kênh số quá tải cũng làm chậm dịch vụ [C4]. Nhóm chưa có số đo thời gian xác nhận, phải đo khi thử nghiệm."

**11. Có bằng chứng QR tăng doanh thu không?**
"Dạ, nhóm chỉ thấy số do nhà cung cấp công bố. Tốt nhất là Centro, công suất giờ cao điểm tăng hơn 20%, sai đơn còn 1–2 đơn mỗi ngày [C24]; các số về tăng giá trị đơn là 12–15% [C23]. Chưa có nghiên cứu độc lập, và các quán đó không chắc có bước xác nhận như nhóm, nên nhóm không dùng làm cam kết. Lý do nhóm làm QR là giảm nhập sai và nhân lực ghi món."

**12. Khách ở nhà quét ảnh QR đặt đơn phá thì sao?**
"Dạ, đơn nằm ở `awaiting`, không chiếm bàn, không vào hàng đợi; thu ngân từ chối. SEC-REMOTE có ghi điều này. Rate limit theo uid chỉ thêm khi có spam. Sapo đã có giới hạn yêu cầu liên tiếp [C11], nên có thể nâng ưu tiên."
*Hỏi tiếp: "Spam 100 đơn thì sao?"* → "Dạ, thu ngân sẽ bị ngập danh sách. Đây là rủi ro còn lại của v1."

**13. Vì sao chỉ thanh toán sau `served`? Đơn mang đi thì sao?**
"Dạ, BR-PAY-04 dùng một luồng trạng thái thống nhất cho trả sau. Mang đi được đánh dấu `served` khi trao món, và thu tiền tại quầy cùng lúc. Nhược điểm là đã pha trước khi có tiền. Đây không phải thông lệ chung: Starbucks thu tiền ngay lúc đặt [C28], iPOS tách riêng hai mô hình trả trước và trả sau [C13], nên hướng đúng về lâu dài là cho chọn theo quán. Nhóm đã cân nhắc ở OI-01."
*Hỏi tiếp: "Khách mang đi đổi ý sau khi pha thì sao?"* → "Dạ, trưởng ca huỷ, tick 'Đã pha', ghi hao hụt theo BR-INV-02."

**14. Khách đã `served` gọi thêm, đơn về `pending`. Một người muốn trả tiền về trước thì sao?**
"Dạ, v1 phải chờ lượt mới xong và `served` mới thanh toán được, nên đây là điểm cứng của BR-PAY-04. Không có tách hoá đơn nên chưa xử lý được trường hợp này. Hướng sửa là cho thanh toán theo lượt hoặc theo món."

**15. Bàn 4 người muốn trả riêng thì sao?**
"Dạ, v1 chưa làm. UC46 chỉ chia theo phương thức, không chia theo người, nên không được gọi là tách bill. Square phân biệt rõ hai việc này [C27], iPOS có 'tách hóa đơn' [C13]. Nhóm mới có gộp bàn. Đây là khoảng trống rõ nhất của mô hình trả sau."

**16. Vì sao chỉ gộp bàn khi cả hai đơn đã `served` và không có voucher, không có khách thành viên?**
"Dạ, BR-ORD-08 và OI-05: tránh phải tính lại ưu đãi và trạng thái pha khác nhau trên một đơn. Đơn nguồn được đóng, không trừ kho."
*Hỏi tiếp: "Khách muốn gộp lúc đang pha?"* → "Dạ phải chờ đến khi `served`. Có thể gây bất tiện, là đánh đổi để giữ tính đúng."

**17. Thanh toán xong phát hiện tính sai, hoàn tiền ở đâu?**
"Dạ, chưa có. `paid` là trạng thái kết thúc và không có luồng hoàn tiền. Đây là thiếu sót nghiệp vụ, cần thêm giao dịch đảo có người duyệt, không sửa đơn cũ, để giữ sổ sách."

**18. Khách uống xong bỏ về không trả?**
"Dạ, UC27 có đúng trigger này: trưởng ca hoặc quản lý huỷ đơn, ghi lý do, tick 'Đã pha' để trừ hao hụt. Doanh thu không ghi nhận, BR-RPT-01. Trả sau thì luôn có rủi ro này; quán muốn tránh thì phải thu trước."

**19. Hàng đợi FIFO có tối ưu không? Starbucks đã bỏ FIFO rồi mà?**
"Dạ, Starbucks có Smart Queue vì nhiều kênh chạy song song, với mục tiêu 4 phút tại quầy và 12 phút cho mobile [C5]. BrewBoss chỉ có một cửa vào là thu ngân, nên FIFO đủ cho v1 và dễ giải thích với nhân viên. Có người phân tích là thuật toán thôi không đủ, còn phải đủ người [C5]."

### C. Tiền và kiểm soát nội bộ

**20. Trưởng ca của em khác gì Starbucks?**
"Dạ, BrewBoss số hoá ba nhiệm vụ: huỷ đơn đã pha, kiểm kho, xem báo cáo tiền. Nguồn là 'run shifts' và 'cash controller responsibilities' [C1]. Phần 'directing partners to workstations' trong app chưa có chức năng, chỉ nằm ở mô tả vai trò."

**21. Thu ngân thấy số dự kiến rồi mới đếm tiền, thì đếm làm gì?**
"Dạ, đó là lỗi thiết kế của UC44 bước 2 hiện tại. Thực hành ngành là blind count: đếm trước khi thấy số hệ thống [C22]. Sửa rất ít: đổi thứ tự hiển thị, nhóm đã ghi nhận." *(Nếu đã sửa, nói: "Dạ, nhóm dùng blind count theo UC44.")*

**22. Một ngăn kéo tiền, hai thu ngân cùng ca thì cân thế nào?**
"Dạ, tiền dự kiến của BR-STAFF-04 tính theo từng người, nên giả định mỗi người có ngăn kéo riêng hoặc tại một thời điểm chỉ một người giữ. SRS chưa ghi rõ, mà mục 1 lại cho phép 'one or more' thu ngân. Square tổ chức theo phiên ngăn kéo, tách khỏi ca chấm công của từng người [C27]. Nhóm cần thêm rule: một ngăn kéo, một người chịu trách nhiệm tại một thời điểm."

**23. Đổi ca giữa ngày, tiền đầu ca người sau có khớp tiền cuối người trước không?**
"Dạ, chưa có kiểm tra. Tiền đầu ca do người nhận tự nhập. Cần so `openingCash` với `closingCash` ca trước và cảnh báo lệch."

**24. Khách trả tiền mặt, thu ngân bấm là đã nhận chuyển khoản rồi bỏ túi. Ngăn kéo vẫn khớp, em phát hiện thế nào?**
"Dạ, cuối ca sẽ không phát hiện được, vì VietQR không tính vào tiền dự kiến. Chỉ phát hiện khi so tổng `qrSales` với sao kê ngân hàng. Tài liệu hiện chưa có bước đó, nên nhóm đề xuất Manager đối soát hằng ngày, và lâu dài dùng báo biến động số dư [C15] để hệ thống tự xác nhận."

**25. Thu ngân lấy gì để kiểm tra tiền về? Đưa app ngân hàng của chủ cho nhân viên à?**
"Dạ, UC25 viết 'checks the bank app', chưa ghi rõ thiết bị. Không nên đưa quyền đăng nhập. Thực tế dùng thông báo biến động số dư hoặc loa báo. iPOS có âm thanh báo khi thanh toán thành công [C13]."

**26. Khách đưa ảnh bill chuyển khoản thì sao? Vì sao QR động?**
"Dạ, không chấp nhận ảnh bill, vì bill giả tạo rất dễ [C16]; UC25 yêu cầu kiểm tra rồi mới bấm. QR hiển thị trên màn hình tạo theo từng đơn, nên không có QR tĩnh để dán đè. Mã đơn nằm trong nội dung chuyển khoản để đối chiếu."

**27. Lấy tiền ngăn kéo mua đá, trả shipper thì ghi vào đâu?**
"Dạ, chưa có nghiệp vụ chi tiền từ ngăn kéo. Hiện nó sẽ thành chênh lệch và phải ghi chú, nên thu ngân làm đúng vẫn bị báo thiếu. Shopify khuyên ghi riêng các khoản này [C22], Square có paid in/out [C27]. Trước mắt phải cấm chi từ ngăn kéo; sau đó thêm sổ thu chi có người duyệt."

**28. Trưởng ca thu tiền mặt của đơn `served`, rồi tự huỷ đơn đó. Em phát hiện thế nào?**
"Dạ, đây là khe hở phân quyền. Trưởng ca vừa thu được vừa huỷ được, và không có người thứ hai duyệt. Đơn huỷ có `cancelledBy` và lý do, xem được ở S20 lọc theo trạng thái, nhưng chưa có báo cáo huỷ đơn hay cảnh báo cho quản lý. Biện pháp: thêm chỉ số huỷ theo người vào S19, cảnh báo quản lý khi huỷ đơn đã `served`, và đối chiếu với chênh lệch kho vì hao hụt tick tay. Xem thêm câu 51: thu ngân cũng có đường tương tự."

**29. Khách trả đủ tiền mặt, thu ngân nhập voucher rồi lấy phần chênh. Em chặn thế nào?**
"Dạ, BR-DIS-03 đã bỏ giảm giá tay, voucher có giới hạn lượt và người dùng được ghi lại, nhưng chưa chặn hẳn kiểu này. Cần báo cáo lượt dùng voucher theo thu ngân, để thấy bất thường."

**30. Quản lý có quyền CRUD trên đơn hàng, vậy có sửa được doanh thu không?**
"Dạ, ma trận hiện ghi Manager CRUD, nghĩa là về kỹ thuật có thể, và điều đó trái với NFR-AUD-01. Luckin cho thấy doanh số giả là rủi ro có thật [C19]. Đơn `paid` và sổ kho phải bất biến với mọi vai trò; nhóm sửa Security Rules." *(Xem Phần 1 mục 4.)*

### D. Kho và giá vốn

**31. Vì sao trừ kho lúc thanh toán chứ không lúc pha? Lúc pha mới thật sự dùng nguyên liệu mà.**
"Dạ, đúng là tồn sẽ trễ so với thực tế trong lúc đơn còn mở. Đổi lại, đơn sửa hay huỷ không phải bù trừ, và NFR-REL-01 giữ doanh thu với kho khớp nhau. iPOS cũng cập nhật theo món bán ra [C13]."
*Hỏi tiếp: "Hết nguyên liệu giữa chừng thì sao?"* → "Dạ, cảnh báo có thể đến muộn hơn, và stock được phép âm. Sold out vẫn do nhân viên bật tay ở UC09, chưa tự động."

**32. Stock âm là vô lý, sao cho phép?**
"Dạ, cố ý. Không thể chặn bán khi đồ đã pha và đã giao chỉ vì số liệu sai. Âm là dấu hiệu dữ liệu lệch, S10 tô đỏ để kiểm kho."

**33. Topping không trừ kho, với quán trà sữa thì sai lớn đấy.**
"Dạ, BR-INV-04 là quyết định cắt phạm vi, chỉ sửa qua kiểm kho. iPOS đã làm 'đến từng gram topping' [C13], nên đây là khoảng cách với thị trường. Vì vậy v1 hợp với quán cà phê hơn quán trà sữa. Nâng cấp là thêm công thức topping và lưu topping id."

**34. Kiểm kho bao lâu một lần? Ai kiểm?**
"Dạ, UC42 ví dụ cuối tuần. Highlands đào tạo kiểm kê hằng ngày, giữa tháng, cuối tháng [C10], nên nguyên liệu giá trị cao nên đếm dày hơn. Kiểm kho toàn phần thì theo chu kỳ. Hiện tài liệu chưa phân nhóm nguyên liệu."

**35. Trưởng ca vừa làm hao hụt vừa kiểm kho, tự che được à?**
"Dạ, về nguyên tắc là có thể, vì UC42 chưa có người thứ hai duyệt. Mọi điều chỉnh có người và giờ theo NFR-AUD-01, nhưng cần Manager duyệt khi chênh lệch vượt ngưỡng."

**36. Sao không đếm kho tự động cho hiện đại?**
"Dạ, Starbucks triển khai cho hơn 11.000 cửa hàng rồi ngừng vào tháng 5/2026 [C7], nên đếm tay vẫn là cách hợp lý với quán nhỏ. Lưu ý là Starbucks không công bố đó là thất bại kỹ thuật."

**37. Công thức có đúng 100% không? Pha lệch, làm lại đồ thì sao?**
"Dạ, không. BR-INV-03 không ghi theo từng ly; cuối cùng gộp vào kiểm kho. Toast cũng nói tiêu hao thực tế luôn cao hơn lý thuyết [C21]. Nhược điểm là không tách được nguyên nhân chênh lệch; Café Crêpe cho thấy muốn tìm nguyên nhân nhanh thì phải có dữ liệu pha chế và hao hụt [C25]."

**38. Lãi mỗi ly bao nhiêu? Báo cáo của em chỉ có doanh thu mà?**
"Dạ, đúng. Nhập kho có `cost` nhưng không bắt buộc, nên chưa tính được giá vốn. UC36 đặt mục tiêu ra quyết định về menu, nhưng hiện chỉ dựa vào doanh thu và số lượng. Đây là việc tiếp theo: giá vốn công thức và chênh lệch lý thuyết - thực tế [C21]."

**39. Mua cà phê theo kg, sữa theo hộp, công thức theo gram, quy đổi thế nào?**
"Dạ, v1 chỉ có một đơn vị g, ml, pcs cho mỗi nguyên liệu; quản lý tự quy đổi khi nhập. Chưa có đơn vị mua hàng và chưa theo dõi hạn dùng. Sai quy đổi sẽ lộ ra khi kiểm kho."

### E. Khách hàng thân thiết

**40. Vì sao dùng số điện thoại mà không làm app như Starbucks?**
"Dạ, Starbucks có quy mô để nuôi app và thẻ trả trước [C2]. Quán nhỏ thì khách không cài app riêng. Highlands cũng có tích điểm tại quầy [C9]. Số điện thoại là cách ít ma sát nhất."

**41. Nói số điện thoại người khác thì tiêu được điểm của họ à?**
"Dạ, hiện đúng là vậy. UC38 và UC39 không xác thực; thu ngân cũng có thể gắn số của mình vào đơn của khách không tích điểm để gom điểm. Tài liệu Square cũng mô tả đổi thưởng tại quầy chỉ bằng tên hoặc số điện thoại [C27], nên đây là đánh đổi có thật giữa tiện lợi và an toàn, không hẳn là sai. Nhưng nhóm phải công khai đánh đổi đó, có lịch sử đổi điểm theo thu ngân và cách xử lý tranh chấp; số dư lớn thì nên có OTP."

**42. 10.000 ₫ được 1 điểm, 1 điểm đổi 1.000 ₫, tức hoàn 10%. Quán chịu nổi không?**
"Dạ, đó là giá trị mặc định, quản lý đổi được ở UC29; nhóm chưa có căn cứ biên lợi nhuận. So sánh thì hạng Green của Starbucks tại Mỹ tính ra khoảng 3,3% theo cách nhóm tự tính [C3]. Nên 10% là cao, nhóm sẽ hạ mặc định và bổ sung lý do. Điểm hiện cũng không có hạn; sao Green của Starbucks có hạn 6 tháng nếu không hoạt động [C3]."

**43. Voucher cộng điểm cùng lúc có giảm chồng không?**
"Dạ có. BR-ORD-02 trừ cả hai, BR-DIS-01 chỉ giới hạn một voucher. Còn được tích điểm trên phần thực trả theo BR-LOY-01. Tài liệu chưa có rule cấm chồng; để tránh giảm quá sâu cần thêm trần."

**44. Thu số điện thoại có xin đồng ý không? Có luật không?**
"Dạ, Luật Bảo vệ dữ liệu cá nhân 91/2025/QH15 hiệu lực từ 01/01/2026 [C18]. UC38 hiện không ghi nhận đồng ý, và SDS không có trường này. Cần thêm `consentAt` và nội dung đồng ý, lấy khi tạo khách."

### F. Báo cáo, pháp lý, vận hành

**45. Doanh thu của em có đúng là doanh thu kế toán không?**
"Dạ không. BR-RPT-01 chỉ là doanh thu quản trị, tổng `total` của đơn `paid`. Kế toán và thuế nằm ngoài phạm vi."

**46. Quán thu tiền, có xuất hoá đơn không? Phiếu của em có giá trị pháp lý không?**
"Dạ, UC28 chỉ là phiếu PDF, không phải hoá đơn. E-invoice đang ngoài phạm vi. NĐ 254/2026 đã thay NĐ 123 từ 01/07/2026, và nguồn thứ cấp nêu hộ doanh thu trên 1 tỉ/năm phải dùng hoá đơn có mã hoặc từ máy tính tiền [C17]. iPOS đã có sản phẩm hoá đơn nối cơ quan thuế [C13]. Muốn dùng thật ở quán trên ngưỡng đó thì phải tích hợp."
*Chú ý: đọc văn bản gốc trước khi nói con số.*

**47. Mất mạng thì quán có bán được không?**
"Dạ, chỉ bán được phần hạn chế. NFR-REL-02 chỉ có cache offline. Tạo đơn và thanh toán đều chạy transaction, mà transaction Firestore cần kết nối. Nên mất mạng lâu là dừng ghi đơn và thu tiền trên app, quán phải ghi tay. Starbucks từng đóng cửa sớm hoặc phát đồ miễn phí do POS ngừng năm 2015 [C6], Toast thì có offline mode và hub cục bộ [C20], còn Offset Coffee từng chạy thanh toán offline qua sự cố hai ngày trên Square [C26]. Nhóm đã đưa offline-first vào ngoài phạm vi và chấp nhận rủi ro này."
*Chú ý: SDS 3.2.1.3 viết "queues writes" chỉ đúng với ghi đơn lẻ như đổi trạng thái pha, không đúng với transaction. Đừng nói là "offline vẫn bán được".*

**48. Thu ngân tự bấm vào ca, chấm công hộ nhau thì sao?**
"Dạ, UC05 hiện tin vào đăng nhập; QR check-in là P2. iPOS dùng FaceID hoặc Wi-Fi cửa hàng [C13]. Mục tiêu G4 mới giải quyết 'bỏ giấy', chưa giải quyết 'chống gian lận'."

**49. Dùng Firebase thì chi phí và rủi ro thế nào?**
"Dạ, SDS ghi cần gói Blaze cho Cloud Functions, và dự kiến một quán nằm trong quota miễn phí, nhưng nhóm chưa có phép tính số lần đọc/ghi cụ thể. Nếu không có Blaze, thông báo chuyển sang listener trong app. Rủi ro là phụ thuộc nhà cung cấp, và SRS chưa đặt mục tiêu khả dụng."

**50. Muốn mở chi nhánh hai thì sao?**
"Dạ, SDS 2.2 ghi mô hình dữ liệu không có branch id, nên phải đổi dữ liệu và Security Rules ở hầu hết collection, đồng thời thêm cấp District Manager đã để ngoài phạm vi. Đây không phải thay đổi nhỏ."

### G. Tình huống biên thầy dễ dựng để thử

**51. Thu ngân thu tiền mặt của bàn đã uống xong, thêm một món để đơn về `pending`, rồi huỷ cả đơn. Có được không?**
"Dạ, theo UC21, BR-ORD-04 và BR-ORD-05 hiện tại thì được, và BR-INV-02 cũng không hiện ô hao hụt ở `pending`. Đây là lỗ hổng do khoá theo trạng thái toàn đơn. Mock-up S14g có khoá lượt cũ, nhưng rule chưa khoá. Phải khoá theo từng lượt: lượt đã bắt đầu pha thì chỉ trưởng ca được huỷ." *(Nếu đã sửa, trả lời theo rule mới.)*

**52. Bàn đang có bill A, khách gọi thêm qua QR, thu ngân từ chối. Bàn có bị trống không?**
"Dạ, UC27 hiện ghi luôn xoá `currentOrderId`, nên theo đúng câu chữ thì có. Đơn `awaiting` không giữ bàn theo BR-ORD-03, nên phải sửa thành chỉ xoá khi bàn trỏ đúng đơn bị huỷ."

**53. Kiểm kho khi khách đang ngồi uống, chưa trả tiền thì sao?**
"Dạ, sẽ bị trừ hai lần. Ví dụ đã pha hết 40 g, đếm còn 960 g, hệ thống chỉnh về 960 g, sau đó thanh toán lại trừ 40 g nữa. Đây là hệ quả của việc trừ kho lúc thanh toán. Với v1, phải kiểm kho khi không còn đơn mở, và cần ghi điều kiện này vào precondition của UC42."
*Hỏi tiếp: "Quán mở 24 giờ thì sao?"* → "Dạ, khi đó phải trừ theo lúc pha hoặc theo dõi phần đã dùng chưa ghi nhận."

**54. Quản lý sửa công thức khi bill đang mở thì trừ theo công thức nào?**
"Dạ, công thức hiện tại. Giá có snapshot nhưng công thức thì không, theo UC15 và UC43. Món đã xoá hoặc thiếu công thức thì bị bỏ qua, không trừ. Cần lưu phiên bản công thức theo đơn."

**55. Đơn bốn ly mới pha một ly, khách huỷ. Ghi hao hụt bao nhiêu?**
"Dạ, UC43 chỉ có một ô 'Đã pha' cho cả đơn: tick thì trừ cả bốn ly, không tick thì không trừ gì. Sai số này nhóm biết trước và sẽ được kiểm kho kéo lại. Hướng đúng là nhập số ly đã pha theo từng dòng."

**56. Tiền đã vào tài khoản nhưng app báo thanh toán thất bại, vì voucher hết lượt hay mất mạng thì sao?**
"Dạ, transaction không thu hồi được tiền ngân hàng; 'nothing is written' chỉ đúng với database. UC25 và UC46 chưa có quy trình cho khoản đã nhận mà đơn chưa `paid`. Nhân viên phải đối chiếu rồi thử lại hoặc hoàn tiền. Nhóm cần thêm trạng thái thanh toán đang xử lý, kèm mã đối soát."

**57. Hai thu ngân cùng bấm thanh toán một bill thì có thu hai lần không?**
"Dạ, trong database thì không, vì transaction đọc lại trạng thái và chỉ một lần chuyển sang `paid` được commit. Nhưng nếu cả hai cùng cho khách quét QR thì vẫn có thể nhận hai khoản thật. Transaction chỉ bảo vệ dữ liệu, không bảo vệ dòng tiền."

**58. Khách thấy giá 40.000 ₫ khi đặt, lúc xác nhận thành 45.000 ₫. Giá nào đúng?**
"Dạ, UC22 lấy giá hiện tại và thu ngân báo lại khách, nên giá lúc gửi chưa phải cam kết cuối. Điểm yếu là việc báo lại chỉ bằng lời, không có bằng chứng khách đồng ý. Trên S17 cần nói rõ giá sẽ được xác nhận."

**59. Khách quét QR có đọc được số điện thoại thành viên của người cùng bàn không?**
"Dạ, có nguy cơ. Sau khi gộp, khách đọc được đơn đích qua `mergedIntoId`, và đơn đó có `customerId` là số điện thoại. Security Rules chỉ cho phép theo cả document, không ẩn được từng trường. Ẩn trên giao diện là chưa đủ; phải có document công khai riêng chỉ chứa trạng thái."

**60. Đơn mở ca trước, trả ca sau, hoặc quán đóng sau nửa đêm thì doanh thu tính cho ai?**
"Dạ, tiền thuộc ca của người xác nhận `paid`, theo BR-PAY-03. Ngày kinh doanh qua nửa đêm thì chưa định nghĩa: `shortId`, dashboard 'hôm nay' và báo cáo đều theo ngày lịch. Quán đóng muộn cần thêm giờ chốt ngày."

**61. `cashDiff` âm có chứng minh nhân viên gian lận không?**
"Dạ không. BR-STAFF-05 chỉ ghi nhận chênh lệch và lý do. Phải xem đếm nhầm, trả thừa, chi từ ngăn kéo, dùng chung ngăn kéo. Hệ thống cung cấp dấu vết, không kết luận lỗi, và không trừ lương."

**62. Trưởng ca thu tiền rồi tự xem báo cáo của mình thì ai kiểm soát?**
"Dạ, UC45 cho xem chứ không phải duyệt, nên Manager phải đối chiếu các ca của trưởng ca. Vai trò trưởng ca của Starbucks chứng minh có vị trí này, không chứng minh họ được tự duyệt [C1]. Trách nhiệm theo ca cũng chưa có trong dữ liệu, vì `shifts` là phiên của từng người, không ghi trưởng ca nào phụ trách ca nào."

**63. Khách đòi huỷ đồ đã pha mà không có trưởng ca, quản lý cũng không nghe máy thì sao?**
"Dạ, tài liệu chưa có người thay thế. Cashier bị chặn theo BR-ORD-05. Không được giải quyết bằng cách cho mượn tài khoản; cần ủy quyền có thời hạn, hoặc quy định mỗi ca phải có người có quyền."

**64. Nhân viên hôm nay đứng quầy, mai pha chế thì sao?**
"Dạ, mỗi tài khoản có một vai trò, nên phải đổi vai trò qua Manager hoặc cấp quyền cao hơn. Starbucks phân vị trí theo ca [C1], còn BrewBoss đã gắn vị trí vào tài khoản. Đây là đánh đổi của việc tách hai vai trò; về lâu dài nên tách quyền của người khỏi vị trí trong ca."

**65. Khách ngồi 60 phút rồi gọi thêm, món mới có bị báo trễ không?**
"Dạ có. UC30 xếp và tính trễ theo `createdAt` của đơn, nên món vừa gọi có thể đỏ ngay và xếp trước khách mới. Cần thời điểm riêng cho từng lượt."

**66. Pha chế phát hiện hết sữa đầu tiên nhưng không được bật hết món, thì báo ai?**
"Dạ, theo 3.1.3 Barista chỉ xem S08, không có quyền chuyển 'Hết hàng'; trên app chưa có đường báo, phải báo miệng cho thu ngân. Nên cân nhắc mở quyền này cho Barista, vì rủi ro thấp."

**67. Đổi đơn vị nguyên liệu đang có tồn từ g sang ml thì sao?**
"Dạ, UC11 AT1 cho sửa đơn vị mà không quy đổi, nên số tồn và công thức sẽ sai nghĩa. Phải khoá đơn vị sau khi đã có giao dịch."

**68. Hai nhóm khách lạ ngồi chung bàn, sao chỉ được một bill? Vì sao gom thanh toán và pha chế vào chung một state machine?**
"Dạ, BR-ORD-03 giả định một bàn là một nhóm thanh toán, chưa phù hợp bàn dùng chung. Chung state machine giúp đơn giản cho trả sau, nhưng thanh toán và pha chế thực ra là hai trục độc lập, như Starbucks thu tiền trước khi pha [C28]. Muốn hỗ trợ trả trước hoặc hoàn tiền một phần thì nên tách làm hai trạng thái."

---

## Phần 5. Điểm yếu xếp theo rủi ro bị hỏi

| Mức | Chủ đề | Câu | Hướng đỡ |
|---|---|---|---|
| Cao | Gian lận VietQR, không đối soát | 24, 25 | Thêm đối soát hằng ngày |
| Cao | Một ngăn kéo nhiều người | 22, 23 | Thêm rule |
| Cao | Không blind count | 21 | Đổi thứ tự UC44 |
| Cao | Trưởng ca tự thu tự huỷ, không có báo cáo huỷ | 28 | Thêm chỉ số vào S19 |
| Cao | Manager sửa được đơn và sổ kho | 30 | Sửa Rules |
| Cao | Thêm món để mở lại quyền huỷ | 51 | Khoá theo lượt |
| Cao | Tiền đã nhận nhưng commit lỗi | 56, 57 | Thêm trạng thái thanh toán đang xử lý |
| Cao | Kiểm kho khi còn đơn mở bị trừ hai lần | 53 | Thêm precondition |
| Cao | Không tách hoá đơn, không hoàn tiền | 14, 15, 17 | Nhận là giới hạn, nêu hướng |
| Cao | Offline | 47 | Không được nói quá |
| Cao | Hoá đơn điện tử | 46 | Sửa nguồn, đọc văn bản gốc |
| Trung bình | Điểm không xác thực, 10%, không đồng ý | 41, 42, 44 | Hạ mặc định, thêm OTP, đồng ý |
| Trung bình | Thiếu vai trò phục vụ | 4 | Nêu vai trò Server |
| Trung bình | Không có giá vốn, lợi nhuận | 38 | Nêu lộ trình |
| Trung bình | Topping | 33 | Giới hạn loại quán |
| Thấp | Thiếu chỉ số trước/sau | 2, 8 | Nói phương án đo |

## Phần 6. Quy tắc khi trả lời

1. **Phân biệt "tài liệu có" với "nhóm đề xuất".** Không nói tính năng chưa có như đã có.
2. **Nói mức bằng chứng.** "Theo tài liệu nhà cung cấp…" khác với "Theo báo cáo cho nhà đầu tư…".
3. **Không dùng từ "thành công" để suy ra nhân quả.** Nói "đang vận hành ở quy mô lớn".
4. **Có phản ví dụ thì nêu luôn** (iPOS đẩy đơn thẳng, Starbucks ngừng công cụ đếm kho). Thầy sẽ đánh giá cao hơn là bị phát hiện.
5. **Không có số thì không đoán.**
6. **Trích dẫn đúng thời điểm.** Số Starbucks phải kèm năm tài chính và phạm vi "tại Mỹ, cửa hàng trực tiếp vận hành".

## Phần 7. Nguồn

Nguồn đánh dấu † mở trực tiếp bị chặn; nội dung lấy qua kết quả tìm kiếm. **Hãy tự mở và chụp lại trước buổi bảo vệ.**

- C2, C4: [Starbucks Q4 FY25 Digital IR Dashboard](https://s203.q4cdn.com/326826266/files/doc_financials/2025/q4/Q4-FY25-Digital-IR-Dashboard.pdf); [Q3 FY26](https://s203.q4cdn.com/326826266/files/doc_financials/2026/q3/Q3-FY26-Digital-IR-Dashboard.pdf)†; [Starbucks press 2026](https://about.starbucks.com/press/2026/starbucks-unveils-reimagined-loyalty-program-to-deliver-more-meaningful-value-personalization-and-engagement-to-members/)†; [NBC 2017](https://www.nbcnews.com/tech/tech-news/it-s-not-just-unicorn-frapp-starbucks-app-overwhelming-baristas-n752316)†; [Restaurant Dive 2024](https://www.restaurantdive.com/news/starbucks-mobile-ordering-is-so-popular-its-slowing-some-orders-down/714933/)†
- C3: [Milesopedia](https://milesopedia.com/en/news/starbucks-rewards-new-3-tier-program/)†; [Joy](https://joy.so/blog/starbucks-loyalty-program/)†
- C5: [GeekWire 2026](https://www.geekwire.com/2026/tech-overhaul-helps-starbucks-post-first-u-s-transaction-growth-in-two-years/)†; [Quartz](https://qz.com/starbucks-mobile-order-labor-barista-workflow-051926)†; [QSR](https://www.qsrmagazine.com/story/people-not-equipment-will-key-starbucks-comeback/)†
- C6: [Fortune](https://fortune.com/2015/04/24/starbucks-systems-outage)†; [NRN](https://www.nrn.com/technology/restaurant-operations-watch-starbucks-pours-ingenuity-during-pos-outage)†
- C7: [GeekWire 2025](https://www.geekwire.com/2025/starbucks-rolls-out-automated-counting-tech-for-inventory-with-help-from-seattle-area-startup/)†; [The Next Web](https://thenextweb.com/news/starbucks-ai-inventory-tool-nomadgo-automated-counting-failure)†; [Let's Data Science](https://letsdatascience.com/news/starbucks-retires-nomadgo-ai-inventory-tool-d8d3c038)
- C8: [Tuổi Trẻ 2025](https://tuoitre.vn/chuoi-ca-phe-lon-nhat-viet-nam-giao-hang-tai-cho-trong-3-phut-buoc-dem-cho-ipo-20250701234758951.htm)
- C9: [Brands Vietnam](https://www.brandsvietnam.com/congdong/topic/highlands-coffee-bat-tay-napas-hien-dai-hoa-va-nang-cao-trai-nghiem-ca-phe-viet)†
- C11: [Sapo QR Order](https://www.sapo.vn/blog/cach-thiet-lap-menu-dien-tu-qr-order-tren-sapo) (bản lưu: `source-evidence/[11]-sapo.vn-qr-order.pdf`)
- C12: [iPOS O2O](https://ipos.vn/san-pham/menu-dien-tu-ipos-o2o/)
- C13: [iPOS trả sau](https://ipos.vn/mo-hinh-quan-ca-phe-tra-sua-tra-sau/); [iPOS trả trước](https://ipos.vn/mo-hinh-quan-ca-phe-tra-sua-tra-truoc/)
- C14: [iPOS phần mềm order](https://ipos.vn/phan-mem-order/)
- C15: [VietQR API](https://api.vietqr.vn/vi/cac-dich-vu-api-khac/host-to-client); [Sapo VietQR PRO](https://www.sapo.vn/blog/tich-hop-mb-bank-trong-giai-phap-thanh-toan-vietqr-pro-tren-sapo)†
- C16: [LuatVietnam](https://luatvietnam.vn/linh-vuc-khac/lam-gia-bill-chuyen-khoan-883-93678-article.html)†; [Thị trường Tài chính Tiền tệ](https://thitruongtaichinhtiente.vn/dan-de-ma-qr-gia-mao-tai-cac-cua-hang-dang-la-chieu-thuc-lua-dao-moi-48628.html)†
- C17: [EY](https://www.ey.com/vi_vn/technical/tax/tax-and-law-updates/nghi-dinh-254-2026-nd-cp-ve-hoa-don-dien-tu-va-chung-tu-dien-tu); [MAN](https://thue.man.net.vn/nghi-dinh-254-2026/); [Thư viện Pháp luật](https://thuvienphapluat.vn/phap-luat-doanh-nghiep/bai-viet/chinh-thuc-da-co-nghi-dinh-thay-the-nghi-dinh-123-va-nghi-dinh-70-ve-hoa-don-dien-tu-nghi-dinh-254-2026-nd-cp-22136.html)†
- C18: [Thị trường Tài chính Tiền tệ](https://thitruongtaichinhtiente.vn/nhung-diem-chinh-can-luu-y-tai-luat-bao-ve-du-lieu-ca-nhan-chinh-thuc-co-hieu-luc-tu-ngay-1-1-2026-75881.html)†; [NĐ 356/2025](https://thuvienphapluat.vn/van-ban/Quyen-dan-su/Nghi-dinh-356-2025-ND-CP-huong-dan-Luat-Bao-ve-du-lieu-ca-nhan-687428.aspx)†
- C19: [Wikipedia](https://en.wikipedia.org/wiki/Luckin_Coffee)†; [Marketplace 2024](https://www.marketplace.org/story/2024/03/01/the-dramatic-recovery-of-chinas-luckin-coffee-chain-draws-fans-and-skeptics)†
- C20: [Toast Offline](https://doc.toasttab.com/doc/platformguide/platformOfflineMode.html)†; [Smart Company về Square](https://www.smartcompany.com.au/finance/square-outage-response-tech-communications-offline-mode/)†
- C21: [Toast xtraCHEF Analytics](https://support.toasttab.com/en/article/xtraCHEF-Inventory-Analytics)†
- C22: [RMH Blind closeouts](https://docs.rmhpos.com/1377502/Content/Topics/POS_UG_Topics/performing-blind-closeouts.html)†; [Shopify](https://www.shopify.com/blog/balancing-a-cash-drawer)†; [WCPOS](https://docs.wcpos.com/pos/reconciliation)†
- C23: [Sunday](https://sundayapp.com/?p=112018)†; [DoorDash](https://merchants.doordash.com/en-us/blog/success-story-curry-up-now)†; [Union](https://getunion.com/?p=27850)†
- C24: [Olo — Centro Restaurant Group](https://www.olo.com/case-studies/centro-restaurant-group)
- C25: [TouchBistro + MarketMan — Café Crêpe](https://www.touchbistro.com/wp-content/uploads/2021/02/CONTENT1039_Cafe_Crepe_Case_Study_Reduced_V2.pdf)
- C26: [Square — Offset Coffee](https://squareup.com/us/en/the-bottom-line/case-studies/offset-coffee)
- C27: [Square — phiên ngăn kéo](https://squareup.com/help/us/en/article/8344-start-and-end-a-cash-drawer-session); [Square — tách bill và tách thanh toán](https://squareup.com/help/gb/en/article/8165-split-a-payment-and-check-with-square-for-restaurants); [Square — đổi thưởng](https://squareup.com/help/us/en/article/5347-how-customers-redeem-their-rewards)
- C28: [Starbucks — Mobile Order & Pay fact sheet 2015](https://about.starbucks.com/uploads/2019/01/Fact_Sheet_-_Mobile_Order__Pay_Expansion_2015-1.pdf)†
- C29: [iPOS — The Coffee House](https://ipos.vn/the-coffee-house/); [Báo Pháp luật — thị trường chuỗi cà phê, 05/2026](https://doanhnhan.baophapluat.vn/cuc-dien-thi-truong-ca-phe-chuoi-highlands-thu-gan-300-ty-dong-ebitda-the-coffee-house-lien-tuc-thu-hep-quy-mo.html)
- C30: [Glory — Grupo Las Palomas](https://www.glory-global.com/en-gb/resources/en_gb/customer-case-studies/grupo-las-palomas)
