/** 日期显示工具：后端 Date 序列化为 ISO 字符串（如 2026-08-27T16:00:00.000+00:00） */
function ymd(v) {
  if (!v) return ''
  const d = v instanceof Date ? v : new Date(v)
  return isNaN(d.getTime()) ? '' : d.toLocaleDateString('sv-SE')
}

function fmtDateTime(v) {
  if (!v) return ''
  const d = v instanceof Date ? v : new Date(v)
  if (isNaN(d.getTime())) return ''
  const p = (n) => String(n).padStart(2, '0')
  return (
    d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate()) +
    ' ' + p(d.getHours()) + ':' + p(d.getMinutes())
  )
}

module.exports = { ymd, fmtDateTime }
